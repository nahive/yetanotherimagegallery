//
//  MainAssembly.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import Swinject

// Normally I split assemblies into different
// types based on what's the purpose, but here
// the quantity of depencies is so small it serves
// no purpose.

class MainAssembly: AssemblyType {
    
    func assemble(container: Container) {
        container.register(MainWorkflowType.self) { _ in
            return MainWorkflow(container: container)
        }.inObjectScope(.container)
        
        container.register(FlickrServiceType.self) { _ in
            return FlickrService(baseURLString: "https://api.flickr.com")
        }.inObjectScope(.container)
        
        container.register(GalleryViewType.self) { r in
            return GalleryViewController()
        }.initCompleted { r, c in
            c.presenter = r.resolve(GalleryPresenterType.self)!
        }
        
        container.register(GalleryPresenterType.self) { r in
            let v = r.resolve(GalleryViewType.self)!
            let s = r.resolve(FlickrServiceType.self)!
            let w = r.resolve(MainWorkflowType.self)!
            return GalleryPresenter(view: v, service: s, workflow: w)
        }
        
        container.register(PhotoViewType.self) { r in
            return PhotoViewController()
            }.initCompleted { r, c in
                c.presenter = r.resolve(PhotoPresenterType.self)!
        }
        
        container.register(PhotoPresenterType.self) { r in
            let v = r.resolve(PhotoViewType.self)!
            let w = r.resolve(MainWorkflowType.self)!
            return PhotoPresenter(view: v, workflow: w)
        }
    }
}
