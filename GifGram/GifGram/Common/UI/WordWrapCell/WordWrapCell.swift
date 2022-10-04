//
//  WordWrapCell.swift
//  GifGram
//
//  Created by 오준솔 on 2022/10/03.
//

import UIKit
import SwiftyGif
import Combine

class WordWrapCell: UICollectionViewCell {
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    var data: String? {
        didSet {
            wordLabel.text = data
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        self.contentView.addSubview(wordLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor
                .constraint(equalTo: self.contentView.topAnchor),
            wordLabel.leftAnchor
                .constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            wordLabel.rightAnchor
                .constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            wordLabel.bottomAnchor
                .constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
