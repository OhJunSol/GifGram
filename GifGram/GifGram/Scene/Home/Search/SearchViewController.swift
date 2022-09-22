//
//  SearchViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit
import Combine

protocol SearchViewControllerProtocol {
    var viewModel: SearchViewModel { get }
}

class SearchViewController: UIViewController, SearchViewControllerProtocol {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = SearchViewModel()
    private var searchItem: DispatchWorkItem?
    private var cancellables: Set<AnyCancellable> = []
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.register(GifCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "Cell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        //Auto focus
        searchBar.becomeFirstResponder()
        
        //Cancel button action
        cancelButton.tapPublisher.sink {
            [weak self] _ in
            self?.navigationController?.popViewController(animated: false)
        }.store(in: &cancellables)
        
        //Gif items update
        viewModel.$gifViewModels
            .receive(on: RunLoop.main)
            .sink {
                [weak self] gifModels in
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }.store(in: &cancellables)
        
        //Error Handling
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink {
                [weak self] error in
                guard let error = error else { return }
                self?.showError(error: error)
            }.store(in: &cancellables)
        
        //NumberOfColumns changed
        viewModel.$numberOfColumns
            .receive(on: RunLoop.main)
            .sink {
                [weak self] numberOfColumns in
                let layout = self?.collectionView.collectionViewLayout as? PinterestLayout
                layout?.changeNumberOfColumns(numberOfColumns: numberOfColumns)
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }.store(in: &cancellables)
        
        //Search text did changed
        searchBar.textPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] searchText in
                print(searchText)
                guard let self = self else { return }
                
                //For throttled search
                self.searchItem?.cancel()
                guard !searchText.isEmpty else {
                    self.reset()
                    return
                }
                
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    self.search(query: searchText)
                }
                
                self.searchItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2),
                                              execute: requestWorkItem)
            }.store(in: &cancellables)
    }

    private func reset() {
        let layout = collectionView.collectionViewLayout as? PinterestLayout
        layout?.reset()
        viewModel.reset()
        collectionView.reloadData()
    }
    
    private func search(query: String) {
        guard viewModel.query != query else { return }
        
        reset()
        viewModel.search(query: query)
    }
    
    private func showError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let dialogMessage = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            
            dialogMessage.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
}

//SearchBar delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchItem?.cancel()
        searchBar.resignFirstResponder()
        
        guard let query = searchBar.text, !query.isEmpty else { return }
        search(query: query)
    }
}

//Collection view delegate
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as! GifCollectionViewCell
        
        cell.bind(viewModel: viewModel.gifViewModels[indexPath.row])
        
        return cell
    }
    
    //infinite scroll
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.count - 10 && !viewModel.isPaginating {
            viewModel.fetchNextGifs()
        }
    }
}

//Pinterest layout delegate
extension SearchViewController: PinterestLayoutDelegate {
    
    func numberOfItemsInCollectionView() -> Int {
        return viewModel.count
    }
    
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let insets = collectionView.contentInset
        let collectionViewWidth = collectionView.bounds.width - (insets.left + insets.right)
        
        let width = self.viewModel.gifViewModels[indexPath.row].width
        let height = self.viewModel.gifViewModels[indexPath.row].height
        let ratio = collectionViewWidth / CGFloat(viewModel.numberOfColumns) / width
        
        return height * ratio
  }
}
