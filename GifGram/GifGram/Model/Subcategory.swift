//
//  Subcategory.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

struct Subcategory {
    let name: String?
    let name_encoded: String?
}

extension Subcategory: Decodable {

    enum CodingKeys: String, CodingKey {
        case name
        case name_encoded
    }
}
