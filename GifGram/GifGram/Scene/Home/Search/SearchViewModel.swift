//
//  SearchViewModel.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation
import UIKit
import Combine


class SearchViewModel {
    
    //Network session
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private var cancellables: [AnyCancellable] = []
    private var observable: AnyCancellable?
    
    //Fetch gifs limit
    private let limit: Int = 20
    
    //Gif viewmodels
    @Published var gifViewModels: [GifViewModel] = []
    
    //Error publisher
    @Published var error: Error?
    
    //Number of columns publisher
    @Published var numberOfColumns: Int = 2
    
    let numberOfSections: Int = 1
    var count: Int {
        return gifViewModels.count
    }
    var isPaginating: Bool = false
    
    //Current query string
    var query: String = ""
    
    init () {
        observeSettings()
    }
    
    deinit {
        observable?.cancel()
        observable = nil
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    private func observeSettings() {
        observable = SettingManager.defaultManager.$numberOfColumns
            .sink { [weak self] numberOfColumns in
                guard let self = self else { return }
                self.numberOfColumns = numberOfColumns
            }
    }
    
    //Reset view model
    func reset() {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
        self.query.removeAll()
        isPaginating = false
        gifViewModels.removeAll()
    }
    
    func search(query: String) {
        reset()
        self.query = query
        fetchNextGifs()
    }
    
    func fetchNextGifs() {
    
        isPaginating = true
        let resource = Resource<GifResponse>.searchGifs(query: query, limit: limit, offset: count)
        networkService.load(resource)
            .map({ gifs -> Result<GifResponse, Error> in Result.success(gifs)})
            .catch({ error -> AnyPublisher<Result<GifResponse, Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.isPaginating = false
                switch value {
                case .success(let response):
                    guard response.pagination.count != 0 else { return }
                    
                    self.gifViewModels.append(contentsOf: response.data.compactMap({ gif in
                        guard let gifURL = gif.images?.fixed_width.url,
                              let url = URL(string: gifURL),
                              let width = gif.images?.fixed_width.width,
                              let height = gif.images?.fixed_width.height else { return nil }
                        
                        let gifViewModel = GifViewModel(url: url, width: CGFloat((width as NSString).floatValue), height: CGFloat((height as NSString).floatValue))
                        return gifViewModel
                    }))
                case .failure(let error):
                    self.error = error
                }
        }).store(in: &cancellables)
    }
    
}
