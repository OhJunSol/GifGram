//
//  ApiConstants.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct ApiConstants {
    static let apiKey = "iRH7vneeI5PWwT5sxjKfJ2Jgx3zf1X7W"
    static let trendingUrl = URL(string: "https://api.giphy.com/v1/gifs/trending")!
    static let searchUrl = URL(string: "https://api.giphy.com/v1/gifs/search")!
    static let categoriesUrl = URL(string: "https://api.giphy.com/v1/gifs/categories")!
}
