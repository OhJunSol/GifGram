//
//  Resource + Search.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

extension Resource {

    static func searchGifs(query: String, limit: Int, offset: Int) -> Resource<GifResponse> {
        let url = ApiConstants.searchUrl
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "q": query,
            "limit": limit,
            "offset": offset,
        ]
        return Resource<GifResponse>(url: url, parameters: parameters)
    }
}
