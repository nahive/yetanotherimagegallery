//
//  GalleryPresenter.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

protocol GalleryPresenterType: class {
    init(view: GalleryViewType, service: FlickrServiceType, workflow: MainWorkflowType)
    
    func fetchPhotos(tags: String?)
    func presentPhoto(at indexPath: IndexPath)
}

class GalleryPresenter {
    fileprivate weak var view: GalleryViewType!
    fileprivate let service: FlickrServiceType
    fileprivate let workflow: MainWorkflowType
    
    required init(view: GalleryViewType, service: FlickrServiceType, workflow: MainWorkflowType) {
        self.view = view
        self.service = service
        self.workflow = workflow
    }
}

// MARK: GalleryPresenterType
extension GalleryPresenter: GalleryPresenterType {
    func fetchPhotos(tags: String?) {
        service.photos(tags: tags) { [weak self] (result) in
            switch result {
            case .success(let photos): self?.view.present(photos: photos)
            case .failure(error: let error): self?.view.present(error: error)
            }
        }
    }
    
    func presentPhoto(at indexPath: IndexPath) {
        // TODO: implement proper photo passing
//        workflow.presentPhoto(sender: view, photo: )
    }
}
