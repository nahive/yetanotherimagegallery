//
//  MainWorkflow.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import Swinject

protocol MainWorkflowType {
    func start(window: UIWindow)
    func presentPhoto(sender: ViewType, photo: Photo)
}

class MainWorkflow {
    fileprivate let container: Container
    
    init(container: Container) {
        self.container = container
    }
}

// MARK: MainWorkflowType
extension MainWorkflow: MainWorkflowType {
    func start(window: UIWindow) {
        // I know it's adviced agains using force unwrap, but here 
        // we actually want to crash our app in case dependency wasnt
        // injected properly.
        let controller = container.resolve(GalleryViewType.self)!
        let navigationController = UINavigationController(rootViewController: controller.controller!)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func presentPhoto(sender: ViewType, photo: Photo) {
        // Same as here.
        let controller = container.resolve(PhotoViewType.self)!
        controller.controller?.modalTransitionStyle = .crossDissolve
        controller.controller?.modalPresentationStyle = .overCurrentContext
        // Pass photo from previous controller to details.
        controller.presenter.photo = photo
        sender.present(viewType: controller, animated: true, completion: nil)
    }
}
