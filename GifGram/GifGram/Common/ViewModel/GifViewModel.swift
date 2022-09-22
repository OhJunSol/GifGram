//
//  GifViewModel.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/23.
//

import Foundation
import Combine
import UIKit

class GifViewModel {
    
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    @Published var isAnimating: Bool = true
    private var cancellables: [AnyCancellable] = []
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        return URLSession(configuration: config)
    }()
    
    init(url: URL, width: CGFloat, height: CGFloat) {
        self.url = url
        self.width = width
        self.height = height
        
        SettingManager.defaultManager.$isAnimating
            .sink { [weak self] isAnimating in
                guard let self = self else { return }
                self.isAnimating = isAnimating
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    func fetchGif(completion: @escaping (UIImage) -> Void) {
        
        if let gif = CacheManager.defaultManager.cachedImage(url: self.url) {
            completion(gif)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ element -> UIImage in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                guard element.data.count > 0 else { throw URLError(.zeroByteResource) }
                return try UIImage(gifData: element.data)
            })
            .replaceError(with: UIImage(systemName: "xmark.diamond"))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {value in
                guard let gif = value else { return }
                CacheManager.defaultManager.appendImage(url: self.url, image: gif)
                completion(gif)
            }).store(in: &cancellables)
    }
}
