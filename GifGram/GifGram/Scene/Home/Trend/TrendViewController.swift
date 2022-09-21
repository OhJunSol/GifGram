//
//  TrendingViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import Foundation
import UIKit

protocol trendViewControllerDelegate: AnyObject {
    func movoToSearch()
}

class TrendViewController: UIViewController {

    weak var delegate: trendViewControllerDelegate?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }


}

extension TrendViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate.
    }
}
