//
//  FixedWidthImage.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct FixedWidthImage {
    let width: String?
    let height: String?
    let url: String?
    let size: String?
    let mp4: String?
    let mp4_size: String?
}

extension FixedWidthImage: Decodable {

    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
        case size
        case mp4
        case mp4_size
    }
}
