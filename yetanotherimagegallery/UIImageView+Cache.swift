//
//  UIImageView+Cache.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func set(urlString: String?, placeholder: UIImage? = nil, blur: Bool = false, completion: CompletionHandler? = nil) {
        guard let urlString = urlString else { return }
        set(url: URL(string: urlString), placeholder: placeholder, blur: blur, completion: completion)
    }
    
    func set(url: URL?, placeholder: UIImage? = nil, blur: Bool = false, completion: CompletionHandler? = nil) {
        var options: KingfisherOptionsInfo?
        if blur { options = [.processor(BlurImageProcessor(blurRadius: 15))] }
        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: placeholder, options: options, progressBlock: nil, completionHandler: completion)
    }
}
