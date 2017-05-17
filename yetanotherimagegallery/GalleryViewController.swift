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
    
    func present(photos: [Photo])
    func present(error: String)
    func presentIndicator()
    func hideIndicator()
}

class GalleryViewController: UIViewController {
    
    var presenter: GalleryPresenterType!
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: GalleryCollectionLayout())
        return collectionView
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
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.right.equalTo(view.snp.right)
            make.left.equalTo(view.snp.left)
            make.height.equalTo(64)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    // MARK: user actions
    private dynamic func buttonTapped(sender: UIButton) {
        presenter.presentPhoto(at: IndexPath(item: 0, section: 0))
    }
    
    // MARK: helpers
}

// MARK: GalleryViewType
extension GalleryViewController: GalleryViewType {
    func present(photos: [Photo]) {
        
    }
    
    func present(error: String) {
        
    }
    
    func presentIndicator() {
        
    }
    
    func hideIndicator() {
        
    }
}
