//
//  TrendingSearchResponse.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

struct TrendingSearchResponse {
    let data: [String]
    let meta: GifMeta
}

extension TrendingSearchResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
}
