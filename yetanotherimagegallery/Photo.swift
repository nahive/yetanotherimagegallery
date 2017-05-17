//
//  Photo.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 17/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import JASON

class Photo {
    var title: String?
    
    // as it turned out - description in flickr is some random html
    // so I made it private just to store it, but don't display it
    private var description: String?
    
    var author: String?
    var authorId: String?
    
    var takenDate: Date?
    var publishDate: Date?
    
    var imageURL: URL?
    var url: URL?
    
    // those will be hold in string, split by comma
    var tags: String?
    
    init(json: JSON) {
        self.title = json["title"].string
        self.description = json["description"].string
        
        self.author = json["author"].string
        self.authorId = json["author_id"].string
        
        self.takenDate = date(from: json["date_taken"].string)
        self.publishDate = date(from: json["published"].string)
        
        self.imageURL = url(from: json["media"]["m"].string)
        self.url = url(from: json["link"].string)
        
        // as in task desc - convert tags to comma split
        self.tags = json["tags"].string?.components(separatedBy: " ").joined(separator: ", ")
    }
    
    // MARK: parsing helper functions
    
    private func date(from string: String?) -> Date? {
        guard let string = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: string)
    }
    
    private func url(from string: String?) -> URL? {
        guard let string = string else { return nil }
        return URL(string: string)
    }
    
    // MARK: factory
    
    static func array(from json: JSON) -> [Photo] {
        return json.flatMap(Photo.init)
    }
}

    
