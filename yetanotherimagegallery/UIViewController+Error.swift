//
//  UIViewController+Error.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit

extension UIViewController {
    func present(error: String) {
        let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        backgroundView.center = view.center
        backgroundView.frame.size = CGSize(width: 200, height: 200)
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8
        backgroundView.alpha = 0
        
        let label = UILabel()
        label.frame = backgroundView.bounds
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        
        backgroundView.addSubview(label)
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
             backgroundView.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 5.0, options: .curveEaseIn, animations: { 
            backgroundView.alpha = 0.0
        }) { _ in  backgroundView.removeFromSuperview() }
    }
}
