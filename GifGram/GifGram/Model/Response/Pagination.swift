//
//  Pagination.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct Pagination {
    let offset: Int
    let total_count: Int
    let count: Int
}

extension Pagination: Decodable {

    enum CodingKeys: String, CodingKey {
        case offset
        case total_count
        case count
    }
}
