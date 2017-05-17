//
//  PhotoViewController.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

protocol PhotoViewType: ViewType {
    var presenter: PhotoPresenterType! { get set }
}

class PhotoViewController: UIViewController {
    
    var presenter: PhotoPresenterType!
    
    // MARK: init
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    // MARK: setup
    
    // MARK: user actions
    
    // MARK: helpers
}

// MARK: PhotoViewType
extension PhotoViewController: PhotoViewType {
    
}
