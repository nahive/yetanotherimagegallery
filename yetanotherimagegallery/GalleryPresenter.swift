//
//  GalleryPresenter.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

enum GallerySortType {
    case taken, published
    static let all = [taken, published]
    
    var description: String {
        switch self {
        case .taken: return "Taken"
        case .published: return "Published"
        }
    }
}

enum GallerySortOptions {
    case ascending, descending
    static let all = [ascending, descending]
    
    var description: String {
        switch self {
        case .ascending: return "Ascending"
        case .descending: return "Descending"
        }
    }
}

protocol GalleryPresenterType: class {
    
    init(view: GalleryViewType, service: FlickrServiceType, workflow: MainWorkflowType)
    
    func fetchPhotos(tags: String?)
    func presentPhoto(at indexPath: IndexPath)
    func sortPhotos(by type: GallerySortType, options: GallerySortOptions)
}

class GalleryPresenter: NSObject {
    fileprivate weak var view: GalleryViewType!
    fileprivate let service: FlickrServiceType
    fileprivate let workflow: MainWorkflowType
    
    fileprivate var photos: [Photo] = []
    
    required init(view: GalleryViewType, service: FlickrServiceType, workflow: MainWorkflowType) {
        self.view = view
        self.service = service
        self.workflow = workflow
    }
}

// MARK: GalleryPresenterType
extension GalleryPresenter: GalleryPresenterType {
    func fetchPhotos(tags: String?) {
        view.presentIndicator()
        service.photos(tags: tags) { [weak self] (result) in
            self?.view.hideIndicator()
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.view.presentPhotos()
            case .failure:
                self?.view.present(error: "Something went terribly wrong while fetching latest photos.")
            }
        }
    }
    
    func presentPhoto(at indexPath: IndexPath) {
        // TODO: implement proper photo passing
        workflow.presentPhoto(sender: view, photo: photos[indexPath.item])
    }
    
    func sortPhotos(by type: GallerySortType, options: GallerySortOptions) {
        photos.sort {
            let dateA: Date
            let dateB: Date
            
            switch type {
            case .taken:
                dateA = $0.0.takenDate ?? Date()
                dateB = $0.1.takenDate ?? Date()
            case .published:
                dateA = $0.0.publishDate ?? Date()
                dateB = $0.1.publishDate ?? Date()
            }
            
            switch options {
            case .ascending: return dateA > dateB
            case .descending: return dateA < dateB
            }
        }
        
        view.presentPhotos()
    }
}

// MARK: UICollectionViewDataSource
extension GalleryPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionCell.identifier, for: indexPath) as? GalleryCollectionCell else { return UICollectionViewCell() }
        cell.configure(photo: photos[indexPath.item])
        return cell
    }
}
