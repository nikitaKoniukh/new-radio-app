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
        aCoder.encode(broadcasters, forKey: "trackBroadcasters")
        aCoder.encode(participants, forKey: "trackParticipants")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "trackName") as? String
        self.urlAddress = aDecoder.decodeObject(forKey: "trackUrl") as? String
        self.myDescription = aDecoder.decodeObject(forKey: "trackDescription") as? String
        self.broadcasters = aDecoder.decodeObject(forKey: "trackBroadcasters") as? [String]
        self.participants = aDecoder.decodeObject(forKey: "trackParticipants") as? [String]
        
    }
    
    init(name : String,description: String,url : String, broad: [String], par: [String]) {
        self.name = name
        self.myDescription = description
        self.urlAddress = url
        self.broadcasters = broad
        self.participants = par
    }
    
    static func from(cloudantPodcastDocument doc : CloudantRowPodcastDoc) -> Podcast{
        let name = doc.name
        let desc = doc.podcastDescription
        let url = doc.url
        let broad = doc.broadcasters
        let part = doc.participants
        
        return Podcast(name: name, description: desc, url: url, broad: broad, par: part)
    }
    
    static func from(cloudantGenericDocument doc : CloudantGenericDoc) -> Podcast? {
        if doc.type != "podcast" {
            print("wrong doc type")
            return nil;
        }
        
        let name = doc.name!
        let desc = doc.podcastDescription!
        let url = doc.url!
        let broad = doc.broadcasters!
        let part = doc.participants!
        
        return Podcast(name: name, description: desc, url: url, broad: broad, par: part)
    }
    
    var name: String?
    var myDescription: String?
    var urlAddress: String?
    var broadcasters: [String]?
    var participants: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case myDescription = "description"
        case urlAddress = "urlAddress"
        case broadcasters = "broadcasters"
        case participants = "participants"
        
    }
    
}


