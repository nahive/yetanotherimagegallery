//
//  MainWorkflowMock.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 18/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

@testable import yetanotherimagegallery

class MainWorkflowMock {
    var wasStarted = false
    var wasPhotoPresented = false
    var wasSharePresented = false
}

extension MainWorkflowMock: MainWorkflowType {
    func start(window: UIWindow) {
        wasStarted = true
    }
    
    func presentPhoto(sender: ViewType, photo: Photo) {
        wasPhotoPresented = true
    }
    
    func presentShare(sender: ViewType, activityItems: [Any], from view: UIView) {
        wasSharePresented = true
    }
}
