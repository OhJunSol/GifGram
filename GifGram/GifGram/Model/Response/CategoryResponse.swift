//
//  CategoryResponse.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

struct CategoryResponse {
    let data: [Category]
    let pagination: Pagination
    let meta: GifMeta
}

extension CategoryResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case data
        case pagination
        case meta
    }
}

