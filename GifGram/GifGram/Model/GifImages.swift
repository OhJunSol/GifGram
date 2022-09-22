//
//  GifImages.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct GifImages {
    let fixed_width: FixedWidthImage
    let downsized: DownsizedImage
}

extension GifImages: Decodable {

    enum CodingKeys: String, CodingKey {
        case fixed_width
        case downsized
    }
}
