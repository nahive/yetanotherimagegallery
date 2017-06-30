//
//  GalleryPresenter.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

/// Sorting types that can be sorted by
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

/// Sorting options for gallery
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
    func fetchPhotos(tags: String?)
    func presentPhoto(at indexPath: IndexPath)
    func sortPhotos(by type: GallerySortType, options: GallerySortOptions)
    
    func configure(cell: GalleryCollectionCell, for indexPath: IndexPath)
    func numberOfCells() -> Int
}

final class GalleryPresenter {
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
    
    // default value for tags should be nil, but 
    // protocols don't allow default values
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
            case .ascending: return dateA < dateB
            case .descending: return dateA > dateB
            }
        }
        
        view.presentPhotos()
    }
    
    func configure(cell: GalleryCollectionCell, for indexPath: IndexPath) {
        cell.configure(photo: photos[indexPath.item])
    }
    
    func numberOfCells() -> Int {
        return photos.count
    }
}
