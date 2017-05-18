//
//  FlickrServiceMock.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 18/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import Foundation

@testable import yetanotherimagegallery

class FlickrServiceMock {
    var wasServiceCalled = false
    var shouldCallSucceed = false
    
    required init(baseURLString: String) {
        // skip as not needed for mock tests
    }
}

extension FlickrServiceMock: FlickrServiceType {
    func photos(tags: String?, completion: @escaping (ServiceResult<[Photo]>) -> Void) {
        wasServiceCalled = true
        
        if shouldCallSucceed {
            completion(.success(generateMockedData(count: Array(10...30).sample)))
        } else {
            completion(.failure(error: "Call failed"))
        }
    }
    
    /// Not very beautiful pseudo random data gen.
    ///
    /// - Parameter count: of items
    /// - Returns: array of data
    private func generateMockedData(count: Int) -> [Photo] {
        let titles = ["Dog", "Cat", "My favourite", "First ever", "Romantic"]
        let authors = ["John", "Minni", "Donald", "Dadgar", "Guldan"]
        let imageURLs = ["https://cdn.pixabay.com/photo/2015/07/06/13/58/arlberg-pass-833326_960_720.jpg", "http://static.boredpanda.com/blog/wp-content/uploads/2015/01/brothers-grimm-wanderings-landscape-photography-kilian-schonberger-3.jpg", "https://cdn.pixabay.com/photo/2016/08/09/21/54/patagonia-1581878__340.jpg", "http://www.hbc333.com/data/out/141/47923857-landscape-picture.jpg", "http://sciencenordic.com/sites/default/files/imagecache/620x/landskap_1.jpg", "http://media.istockphoto.com/photos/beautiful-rolling-landscape-on-a-summers-day-in-the-cotswolds-picture-id501234002"]
        let takenDates = [Date(timeIntervalSince1970: 123455), Date(timeIntervalSince1970: 123455), Date(timeIntervalSince1970: 31241241), Date(timeIntervalSince1970: 41241235), Date(timeIntervalSince1970: 6436141)]
        let publishedDates = [Date(timeIntervalSince1970: 124455), Date(timeIntervalSince1970: 124553), Date(timeIntervalSince1970: 312141241), Date(timeIntervalSince1970: 41414235), Date(timeIntervalSince1970: 6436411)]
        let tags = ["photo", "instagood", "flickrgood", "puppy", "nature", "beautiful", "love", "privacy", "ignore", "myman"]
        
        return (0..<count).map {_ in 
            let photo = Photo()
            photo.title = titles.sample
            photo.author = authors.sample
            photo.imageURL = URL(string: imageURLs.sample)
            photo.takenDate = takenDates.sample
            photo.publishDate = publishedDates.sample
            photo.tags = "\(tags.sample), \(tags.sample), \(tags.sample)"
            return photo
        }
    }
}

extension Array {
    var sample: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}
