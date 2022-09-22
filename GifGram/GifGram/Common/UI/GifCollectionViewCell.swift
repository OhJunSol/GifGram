//
//  GifCollectionViewCell.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import UIKit
import SwiftyGif
import Combine

class GifCollectionViewCell: UICollectionViewCell {
    
    var viewModel: GifViewModel?
    private var cancellables: [AnyCancellable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor
                .constraint(equalTo: self.contentView.topAnchor),
            imageView.leftAnchor
                .constraint(equalTo: self.contentView.leftAnchor),
            imageView.rightAnchor
                .constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor
                .constraint(equalTo: self.contentView.bottomAnchor),
        ])
        
        self.imageView.image = UIImage(systemName: "photo.artframe")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    override func prepareForReuse() {
        if let image = UIImage(systemName: "photo.artframe") {
            self.imageView.setImage(image)
        }
        
        super.prepareForReuse()
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func bind(viewModel: GifViewModel) {
        self.viewModel = viewModel
        
        //isAnimating changed check
        self.viewModel?.$isAnimating
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isAnimating in
                guard let self = self,
                      isAnimating != self.imageView.isAnimatingGif() else { return }
                isAnimating ? self.imageView.startAnimatingGif() : self.imageView.stopAnimatingGif()
            }).store(in: &cancellables)
        
        //Fetch Gif
        self.viewModel?.fetchGif(completion: { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.imageView.setGifImage(image)
                viewModel.isAnimating ? self.imageView.startAnimatingGif() : self.imageView.stopAnimatingGif()
            }
        })
    }
    
}
