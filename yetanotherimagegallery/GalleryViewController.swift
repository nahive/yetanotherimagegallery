//
//  GalleryViewController.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import SnapKit

protocol GalleryViewType: ViewType {
    var presenter: GalleryPresenterType! { get set }
    
    func presentPhotos()
    func present(error: String)
    func presentIndicator()
    func hideIndicator()
}

class GalleryViewController: UIViewController {
    
    var presenter: GalleryPresenterType!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for tags separated by comma"
        searchBar.keyboardType = .webSearch
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        return searchBar
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GalleryCollectionCell.self, forCellWithReuseIdentifier: GalleryCollectionCell.identifier)
        collectionView.dataSource = (self.presenter as? UICollectionViewDataSource)
        collectionView.delegate = self
        collectionView.backgroundColor = .groupTableViewBackground
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    private lazy var sortNavigationButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortButtonTapped(sender:)))
        return item
    }()
    
    fileprivate lazy var refreshNavigationButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshButtonTapped(sender:)))
        return item
    }()
    
    fileprivate lazy var refreshingNavigationStatus: UIBarButtonItem = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        let item = UIBarButtonItem(customView: activityIndicator)
        return item
    }()
    
    // MARK: init
    override func viewDidLoad(){
        super.viewDidLoad()
        setup()
        
        presenter.fetchPhotos(tags: nil)
    }
    
    // MARK: setup
    private func setup() {
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        navigationItem.title = "Yet another photo app"
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.rightBarButtonItem = sortNavigationButton
        navigationItem.leftBarButtonItem = refreshNavigationButton
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(64)
            make.right.equalTo(view.snp.right)
            make.left.equalTo(view.snp.left)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    // MARK: user actions
    
    private dynamic func sortButtonTapped(sender: UIBarButtonItem) {
        presentSortTypeMenu()
    }
    
    private dynamic func refreshButtonTapped(sender: UIBarButtonItem) {
        presenter.fetchPhotos(tags: searchBar.text)
    }
    
    private func presentSortTypeMenu() {
        // this is a kinda weird solution to make sure all cases in enum are presented
        let controller = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        GallerySortType.all.forEach { item in
            controller.addAction(UIAlertAction(title: item.description, style: .default, handler: { [weak self] action in
                self?.presentSortOptionsMenu(with: item)
            }))
        }
        controller.popoverPresentationController?.barButtonItem = sortNavigationButton
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true)
    }
    
    private func presentSortOptionsMenu(with type: GallerySortType) {
        let controller = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)
        GallerySortOptions.all.forEach { item in
            controller.addAction(UIAlertAction(title: item.description, style: .default, handler: { [weak self] action in
                self?.presenter.sortPhotos(by: type, options: item)
            }))
        }
        controller.popoverPresentationController?.barButtonItem = sortNavigationButton
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true)
    }
    
    // MARK: helpers
}

// MARK: GalleryViewType
extension GalleryViewController: GalleryViewType {
    func present(error: String) {
        alert(message: error)
    }
    
    func presentPhotos() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func presentIndicator() {
        navigationItem.leftBarButtonItem = refreshingNavigationStatus
    }
    
    func hideIndicator() {
        navigationItem.leftBarButtonItem = refreshNavigationButton
    }
}

// MARK: UICollectionViewDelegate 
extension GalleryViewController: UICollectionViewDelegateFlowLayout {    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.presentPhoto(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.size.width/3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: UISearchBarDelegate 
extension GalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.fetchPhotos(tags: searchBar.text)
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" { presenter.fetchPhotos(tags: nil) }
    }
}
