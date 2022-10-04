//
//  Resource + TrendingSearch.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

extension Resource {

    static func trendingSearchTerms() -> Resource<TrendingSearchResponse> {
        let url = ApiConstants.trendingSearchTermsUrl
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
        ]
        return Resource<TrendingSearchResponse>(url: url, parameters: parameters)
    }
}
