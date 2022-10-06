//
//  GifGramTests.swift
//  GifGramTests
//
//  Created by 오준솔 on 2022/09/22.
//

import XCTest
import Combine
@testable import GifGram

class GifGramTests: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private var cancellables: [AnyCancellable] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }

    func test_loadFinishedSuccessfully() throws {
        
        //Given
        let expectation = self.expectation(description: "networkServiceExpectation")
        let resource = Resource<GifResponse>.searchGifs(query: "joker", limit: 10, offset: 0)
        var result: Result<GifResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ gifs -> Result<GifResponse, Error> in Result.success(gifs)})
            .catch({ error -> AnyPublisher<Result<GifResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .success(let gifs) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(gifs.meta.status, 200)
    }

    func test_loadFailedWithRequestError() throws {
        
        //Given
        let url = URL(string: "api.giphy.com/v1/gifs/search")! //removed protocol
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "q": "joker",
            "limit": 10,
            "offset": 0,
        ]
        let resource = Resource<GifResponse>(url: url, parameters: parameters)
        let expectation = self.expectation(description: "networkServiceExpectation")
        var result: Result<GifResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ gifs -> Result<GifResponse, Error> in Result.success(gifs)})
            .catch({ error -> AnyPublisher<Result<GifResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.invalidRequest = networkError else {
            XCTFail()
            return
        }
    }
    
    func test_loadFailedWithInternalError() throws {
        
        //Given
        let url = URL(string: "https://api.giphy.com/v1/gifs/search/wrongURL")! //Wrong URL
        let parameters: [String : CustomStringConvertible] = [
            "api_key": ApiConstants.apiKey,
            "q": "joker",
            "limit": 10,
            "offset": 0,
        ]
        let resource = Resource<GifResponse>(url: url, parameters: parameters)
        let expectation = self.expectation(description: "networkServiceExpectation")
        var result: Result<GifResponse, Error>?
        
        //When
        networkService.load(resource)
            .map({ gifs -> Result<GifResponse, Error> in Result.success(gifs)})
            .catch({ error -> AnyPublisher<Result<GifResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
                    
        // Then
        self.waitForExpectations(timeout: 3.0, handler: nil)
        guard case .failure(let error) = result,
            let networkError = error as? NetworkError,
            case NetworkError.dataLoadingError(statusCode: 404, _) = networkError else {
            XCTFail()
            return
        }
    }

}
