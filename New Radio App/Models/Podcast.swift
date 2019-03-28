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
    
    var name: String?
    var myDescription: String?
    var urlAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case myDescription = "description"
        case urlAddress = "urlAddress"
    }
}


