//
//  DownsizedImage.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct DownsizedImage {
    let width: String?
    let height: String?
    let url: String?
    let size: String?
}

extension DownsizedImage: Decodable {

    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case size
    }
}
