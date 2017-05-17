//
//  AppDelegate.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupStart()
        return true
    }
    
    private func setupStart() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Here's a confusing way to start assembly (to inject dependencies)
        // and to start first workflow (here MainWorkflow)
        // Force unwrap, cause if there's no way that window is nil.
        
        let assembler = try? Assembler(assemblies: [MainAssembly()])
        assembler?.resolver.resolve(MainWorkflowType.self)?.start(window: window!)
    }
}

