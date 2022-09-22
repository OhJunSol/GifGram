//
//  Gif.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct Gif {
    let type: String?
    let id: String?
    let url: String?
    let images: GifImages?
}

extension Gif: Decodable {

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case url
        case images
    }
}
