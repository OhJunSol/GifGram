//
//  CacheManager.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation
import UIKit

class CacheManager {
    
    static let cacheLimit = 100
    public static var defaultManager = CacheManager()
    
    var imageCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = CacheManager.cacheLimit
        return cache
    }()
    
    func reset() {
        imageCache.removeAllObjects()
    }
    
    func cachedImage(url: URL) -> UIImage? {
        imageCache.object(forKey: url as NSURL)
    }
    
    func appendImage(url: URL, image: UIImage) {
        imageCache.setObject(image, forKey: url as NSURL)
    }
}
