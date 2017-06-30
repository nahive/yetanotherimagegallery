//
//  PhotoPresenter.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

protocol PhotoPresenterType: class {
    var photo: Photo! { get set }
    
    init(view: PhotoViewType, workflow: MainWorkflowType)
    
    func open(url: URL?)
    func save(photo: UIImage?)
    func share(photo: UIImage?, from view: UIView)
}

// NSObject is needed as #selectors still depend on obj-c runtime :( 
final class PhotoPresenter: NSObject {
    fileprivate weak var view: PhotoViewType!
    fileprivate let workflow: MainWorkflowType
    
    var photo: Photo!
    
    required init(view: PhotoViewType, workflow: MainWorkflowType) {
        self.view = view
        self.workflow = workflow
    }
    
    dynamic func saveResult(image: UIImage, with error: Error!, contextInfo: AnyObject!) {
        guard error == nil else {
            view.present(message: "Couldn't save photo in library")
            return
        }
        view.present(message: "Photo was saved in library")
    }
}

// MARK: PhotoPresenterType
extension PhotoPresenter: PhotoPresenterType {
    func open(url: URL?) {
        guard let url = url else {
            view.present(message: "Couldn't open url")
            return
        }
        UIApplication.shared.open(url)
    }
    
    func save(photo: UIImage?) {
        guard let image = photo else {
             view.present(message: "Couldn't save photo in library")
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveResult(image:with:contextInfo:)), nil)
    }
    
    func share(photo: UIImage?, from view: UIView) {
        guard let image = photo else {
            self.view.present(message: "Couldn't share photo")
            return
        }
        workflow.presentShare(sender: self.view, activityItems: [image], from: view)
    }
}
