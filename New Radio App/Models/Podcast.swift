//
//  Podcast.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

class Podcast: NSObject, Decodable, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name ?? "", forKey: "trackName")
        aCoder.encode(urlAddress ?? "", forKey: "trackUrl")
        aCoder.encode(myDescription, forKey: "trackDescription")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "trackName") as? String
        self.urlAddress = aDecoder.decodeObject(forKey: "trackUrl") as? String
        self.myDescription = aDecoder.decodeObject(forKey: "trackDescription") as? String
        
    }
    
    init(name : String,description: String,url : String) {
        self.name = name
        self.myDescription = description
        self.urlAddress = url
    }
    
    static func from(cloudantPodcastDocument doc : CloudantRowPodcastDoc) -> Podcast{
        let name = doc.name
        let desc = doc.podcastDescription
        let url = doc.url
        
        return Podcast(name: name, description: desc, url: url)
    }
    
    static func from(cloudantGenericDocument doc : CloudantGenericDoc) -> Podcast? {
        if doc.type != "podcast" {
            print("wrong doc type")
            return nil;
        }
        
        let name = doc.name!
        let desc = doc.podcastDescription!
        let url = doc.url!
        
        return Podcast(name: name, description: desc, url: url)
    }
    
    var name: String?
    var myDescription: String?
    var urlAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case myDescription = "description"
        case urlAddress = "urlAddress"
    }
}


