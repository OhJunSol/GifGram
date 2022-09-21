//
//  ViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }


}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.definesPresentationContext = true
        self.performSegue(withIdentifier: "moveToSearch", sender: nil)
    }
}
