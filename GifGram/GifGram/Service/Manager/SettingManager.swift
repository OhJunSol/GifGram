//
//  SettingManager.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation
import Combine

class SettingManager: NSObject {
    
    public static var defaultManager = SettingManager()
    
    @Published var numberOfColumns: Int = 2
    
    @Published var isAnimating: Bool = true
    
    @Published var trendingSearchTerms: [String] = []
}
