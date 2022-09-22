//
//  PinterestLayout.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    //Get height of indexPath
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
    //Get number of itmes
    func numberOfItemsInCollectionView() -> Int
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private var numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var maxYOffset: [CGFloat] = []
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    func reset() {
        cache.removeAll()
        contentHeight = 0
        maxYOffset.removeAll()
    }
    
    func changeNumberOfColumns(numberOfColumns: Int) {
        guard self.numberOfColumns != numberOfColumns else { return }
        self.numberOfColumns = numberOfColumns
        reset()
        update()
    }
    
    override func prepare() {
        //Need to update check
        let collectionViewItemCount = delegate?.numberOfItemsInCollectionView() ?? 0
        guard cache.isEmpty || collectionViewItemCount > cache.count else { return }
        update()
    }
    
    private func update() {
        guard let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        if maxYOffset.count != numberOfColumns {
            maxYOffset = .init(repeating: 0, count: numberOfColumns)
        }
        
        for index in 0..<yOffset.count {
            yOffset[index] = maxYOffset[index]
        }
        
        var column = 0
        if let minOffset = yOffset.min(), let index = yOffset.firstIndex(of: minOffset) {
            column = index
        }
        
        //Make frame of itmes
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            guard indexPath.row >= cache.count else { continue }
            
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            maxYOffset[column] = yOffset[column]
            
            if let minOffset = yOffset.min(), let index = yOffset.firstIndex(of: minOffset) {
                column = index
            } else {
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
