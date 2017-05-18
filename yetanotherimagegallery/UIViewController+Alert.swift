//
//  UIViewController+Error.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

// Mock implementation of toasts that can display messages
extension UIViewController {
    func alert(message: String) {
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        backgroundView.frame.size = CGSize(width: 150, height: 150)
        backgroundView.center = UIApplication.shared.keyWindow?.center ?? .zero
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8
        backgroundView.alpha = 0
        
        let label = UILabel()
        label.text = message
        label.frame = backgroundView.frame.insetBy(dx: 16, dy: 16)
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0
        
        // Added to keyWindow, so it overlays every view in app
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        UIApplication.shared.keyWindow?.addSubview(label)
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
             backgroundView.alpha = 1.0
            label.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 3.0, options: .curveEaseIn, animations: {
            backgroundView.alpha = 0.0
            label.alpha = 0.0
        }) { _ in
            backgroundView.removeFromSuperview()
            label.removeFromSuperview()
        }
    }
}
