//
//  SearchEmptyViewModel.swift
//  GifGram
//
//  Created by 오준솔 on 2022/10/03.
//

import Foundation
import UIKit
import Combine


class SearchEmptyViewModel {
    
    //Network session
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    private lazy var networkService = NetworkService(session: session)
    private var cancellable: AnyCancellable?
    
    init() {
        setCancellable()
    }
    
    deinit {
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func setCancellable() {
        cancellable = SettingManager.defaultManager.$trendingSearchTerms
            .sink(receiveValue: { [weak self] terms in
                guard let self = self else { return }
                self.trendingSearchTerms = terms
            })
    }
    
    //Trending search terms for empty page
    @Published var trendingSearchTerms: [String] = []

}
