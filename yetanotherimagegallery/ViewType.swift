//
//  ViewType.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

/// Wrapper for UIKit helping with dependency injection (to not pass UIViewControllers)
protocol ViewType: class {
    var controller: UIViewController? { get }
    func present(viewType: ViewType, animated: Bool, completion: (() -> Void)?)
    func push(viewType: ViewType, animated: Bool)
}

extension ViewType where Self:UIViewController {
    var controller: UIViewController? { return self }
    
    func present(viewType: ViewType, animated: Bool, completion: (() -> Void)?) {
        guard let newController = viewType.controller else { fatalError("Trying to present non-UIViewController type") }
        present(newController, animated: animated, completion: completion)
    }
    
    func push(viewType: ViewType, animated: Bool) {
        guard let newController = viewType.controller else { fatalError("Trying to present non-UIViewController type") }
        guard let navigationController = navigationController else { fatalError("No UINavigationController to push from") }
        navigationController.pushViewController(newController, animated: animated)
    }
}
