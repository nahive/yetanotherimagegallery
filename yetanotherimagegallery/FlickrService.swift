//
//  FlickrService.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import Alamofire

protocol FlickrServiceType: class {
    init(baseURLString: String)
    func photos(tags: String, result: (ServiceResult<Photo>) -> Void)
}

class FlickrService {
    fileprivate let baseURLString: String
    
    /// Configures service with provided base URL
    ///
    /// - Parameter url: base string URL (ex. http://api.flickr.com)
    required init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
}

// MARK: FlickrServiceType
extension FlickrService: FlickrServiceType {
    func photos(tags: String, result: (ServiceResult<Photo>) -> Void) {
        let params: Parameters = ["tags": tags]
        let url = baseURLString + "/services/feed/photos_public.gne"
        
        Alamofire.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let json): break
            case .failure(let error): break
            }
        }
    }
}
