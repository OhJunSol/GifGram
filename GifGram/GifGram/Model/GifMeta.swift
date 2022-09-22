//
//  GifMeta.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation

struct GifMeta {
    let msg: String
    let status: Int
}

extension GifMeta: Decodable {

    enum CodingKeys: String, CodingKey {
        case msg
        case status
    }
}
