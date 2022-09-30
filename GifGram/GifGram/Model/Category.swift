//
//  Category.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

struct Category {
    let name: String?
    let name_encoded: String?
    let subcategories: [Subcategory]
    let gif: Gif?
}

extension Category: Decodable {

    enum CodingKeys: String, CodingKey {
        case name
        case name_encoded
        case subcategories
        case gif
    }
}
