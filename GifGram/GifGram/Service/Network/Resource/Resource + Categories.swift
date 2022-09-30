//
//  Resource + Categories.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/30.
//

import Foundation

extension Resource {

    static func categories() -> Resource<CategoryResponse> {
        let url = ApiConstants.categoriesUrl
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
        ]
        return Resource<CategoryResponse>(url: url, parameters: parameters)
    }
}
