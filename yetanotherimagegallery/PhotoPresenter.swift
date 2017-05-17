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
    
}
