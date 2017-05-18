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
    func photos(tags: String?, completion: @escaping (ServiceResult<[Photo]>) -> Void)
}

class FlickrService {
    fileprivate let baseURLString: String
    
    /// Configures service with provided base URL
    ///
    /// - Parameter baseURLString: base string URL (ex. http://api.flickr.com)
    required init(baseURLString: String) {
        self.baseURLString = baseURLString
    }
}

// MARK: FlickrServiceType
extension FlickrService: FlickrServiceType {
    func photos(tags: String?, completion: @escaping (ServiceResult<[Photo]>) -> Void) {
        var params: Parameters = ["format": "json", "nojsoncallback": 1]
        if let tags = tags { params["tags"] = tags }
        
        let url = baseURLString + "/services/feeds/photos_public.gne"
        
        Alamofire.request(url, method: .get, parameters: params).responseCustomJSON { (response) in
            switch response.result {
            case .success(let json):
                completion(.success(Photo.array(from: json["items"])))
            case .failure(let error):
                completion(.failure(error: error.localizedDescription))
            }
        }
    }
}
