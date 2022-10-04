//
//  SearchEmptyView.swift
//  GifGram
//
//  Created by 오준솔 on 2022/10/02.
//

import Foundation
import UIKit
import Combine

protocol SearchItemDelegate: AnyObject {
    func searchItemSelected(item: String)
}

protocol SearchEmptyViewProtocol {
    var viewModel: SearchEmptyViewModel? { get set }
    func bind(viewModel: SearchEmptyViewModel)
}

class SearchEmptyView: UIView, SearchEmptyViewProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: SearchItemDelegate?
    
    var viewModel: SearchEmptyViewModel?
    
    private var cancellables: [AnyCancellable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
        // cell size
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(20),
                heightDimension: .absolute(24)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
                heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
            ),
            subitems: [item]
        )
        // horizontal spacing between cells
        group.interItemSpacing = .fixed(10)
        // vertical spacing between cells
        group.edgeSpacing = .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(4))
        
        return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
    
    func setup() {
        guard let view = Bundle.main.loadNibNamed("SearchEmptyView", owner: self)?.first as? UIView else {
            return
        }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WordWrapCell.self, forCellWithReuseIdentifier: "WordWrapCell")
        
        collectionView.collectionViewLayout = createLeftAlignedLayout()
    }
    
    func bind(viewModel: SearchEmptyViewModel) {
        self.viewModel = viewModel
        
        //Set trending search terms for empty page
        viewModel.$trendingSearchTerms
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] terms in
                self?.collectionView.reloadData()
            }).store(in: &cancellables)
    }
    
}

extension SearchEmptyView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.trendingSearchTerms.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordWrapCell", for: indexPath) as! WordWrapCell
        cell.data = viewModel?.trendingSearchTerms[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Search item delegate
        guard let item = viewModel?.trendingSearchTerms[indexPath.item] else { return }
        delegate?.searchItemSelected(item: item)
    }
}
