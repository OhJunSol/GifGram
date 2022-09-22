//
//  Resource + TrendingGifs.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

extension Resource {

    static func trendingGifs(limit: Int, offset: Int) -> Resource<GifResponse> {
        let url = ApiConstants.trendingUrl
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "limit": limit,
            "offset": offset,
        ]
        return Resource<GifResponse>(url: url, parameters: parameters)
    }
}
