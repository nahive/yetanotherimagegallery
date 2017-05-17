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
    
    init(view: PhotoViewType)
    
    func open(url: URL?)
    func save(photo: UIImage?)
}

class PhotoPresenter {
    fileprivate weak var view: PhotoViewType!
    
    var photo: Photo!
    
    required init(view: PhotoViewType) {
        self.view = view
    }
}

// MARK: PhotoPresenterType
extension PhotoPresenter: PhotoPresenterType {
    func open(url: URL?) {
        guard let url = url else { return }
        UIApplication.shared.open(url)
    }
    
    func save(photo: UIImage?) {
        guard let image = photo else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveResult(image:with:contextInfo:)), nil)
    }
    
    private dynamic func saveResult(image: UIImage, with error: Error!, contextInfo: AnyObject!) {
        guard error == nil else {
            view.present(message: "Couldn't save photo in library")
            return
        }
        view.present(message: "Photo was saved in library")
    }
}
