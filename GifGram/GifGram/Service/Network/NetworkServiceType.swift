//
//  NetworkServiceType.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation
import Combine

protocol NetworkServiceType: AnyObject {

    @discardableResult
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error>
}

enum NetworkError: Error {
    case invalidRequest
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}
