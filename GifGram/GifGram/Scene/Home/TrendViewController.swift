//
//  TrendViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit
import Combine

protocol TrendViewControllerProtocol {
    var viewModel: TrendViewModel { get }
}

class TrendViewController: UIViewController, TrendViewControllerProtocol {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = TrendViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = PinterestLayout()
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.backgroundColor = .clear
        collectionView.register(GifCollectionViewCell.self,
                                     forCellWithReuseIdentifier: "Cell")
        
        
        //Move to search scene when searchBar is clicked
        searchBar.editingDidBeginPublisher.sink { _ in
            self.searchBar.resignFirstResponder()
            self.performSegue(withIdentifier: "moveToSearch", sender: self)
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
        
        //Fetch Gifs
        viewModel.fetchNextGifs()
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

//Collection view delegate
extension TrendViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.count - 10 && !viewModel.isPaginating {
            viewModel.fetchNextGifs()
        }
    }
}

//Pinterest layout delegate
extension TrendViewController: PinterestLayoutDelegate {
    func numberOfColumns() -> Int {
        return viewModel.numberOfColumns
    }
    
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
