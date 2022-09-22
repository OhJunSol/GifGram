//
//  GifResponse.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct GifResponse {
    let data: [Gif]
    let pagination: Pagination
    let meta: GifMeta
}

extension GifResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case data
        case pagination
        case meta
    }
}
