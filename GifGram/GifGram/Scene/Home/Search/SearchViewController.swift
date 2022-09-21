//
//  SearchViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var cancellables: Set<AnyCancellable> = []
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
        
        cancelButton.tapPublisher.sink {
            [weak self] _ in
            self?.dismiss(animated: false)
        }.store(in: &cancellables)
    }


}

