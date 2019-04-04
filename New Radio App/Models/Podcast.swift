//
//  Podcast.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation
import UIKit

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
    var imageLocal:UIImage = imageArrayRandom()
    var isFavorites: Bool = false
    
    
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case myDescription = "description"
        case urlAddress = "urlAddress"
        case broadcasters = "broadcasters"
        case participants = "participants"
        
    }
    
}

var imageArray = [#imageLiteral(resourceName: "p33"), #imageLiteral(resourceName: "p13"), #imageLiteral(resourceName: "p12"), #imageLiteral(resourceName: "p14"), #imageLiteral(resourceName: "p11"), #imageLiteral(resourceName: "p32"), #imageLiteral(resourceName: "p27"), #imageLiteral(resourceName: "p6"), #imageLiteral(resourceName: "p1"), #imageLiteral(resourceName: "p38"), #imageLiteral(resourceName: "p5"), #imageLiteral(resourceName: "p15"), #imageLiteral(resourceName: "p3"), #imageLiteral(resourceName: "p28"), #imageLiteral(resourceName: "p21"), #imageLiteral(resourceName: "p4"), #imageLiteral(resourceName: "p25"), #imageLiteral(resourceName: "p19"), #imageLiteral(resourceName: "p9"), #imageLiteral(resourceName: "p7"), #imageLiteral(resourceName: "p35"), #imageLiteral(resourceName: "p8"), #imageLiteral(resourceName: "p26"), #imageLiteral(resourceName: "p22"), #imageLiteral(resourceName: "p31"), #imageLiteral(resourceName: "p30"),
                  #imageLiteral(resourceName: "p29"), #imageLiteral(resourceName: "p37"), #imageLiteral(resourceName: "p16"), #imageLiteral(resourceName: "p2"), #imageLiteral(resourceName: "p17"), #imageLiteral(resourceName: "p36"), #imageLiteral(resourceName: "p23"), #imageLiteral(resourceName: "p20"), #imageLiteral(resourceName: "p18"), #imageLiteral(resourceName: "p24"), #imageLiteral(resourceName: "p10")]


func imageArrayRandom()->UIImage{
    imageArray.shuffle()
    
    return imageArray[0]
}



