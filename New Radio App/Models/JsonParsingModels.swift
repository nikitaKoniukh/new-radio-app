//
//  JsonParsingModels.swift
//  New Radio App
//
//  Created by Idan Birman on 29/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

struct CloudantRowValue : Codable{
    let rev:String
    
    enum CodingKeys: String,CodingKey {
        case rev
    }
}

struct CloudantRowCommentDoc : Codable{
    let id : String
    let rev : String
    let timeStamp : String
    let podcastID : String
    let type : String
    let message : String
    let userID : String
    
    enum CodingKeys : String,CodingKey {
        case id = "_id"
        case rev = "_rev"
        case timeStamp
        case podcastID
        case type
        case message
        case userID
    }
}

struct CloudantRowPodcastDoc : Codable {
    let id : String
    let rev : String
    let type : String
    let name : String
    let podcastDescription : String
    let broadcasters : [String]
    let url : String
    let participants : [String]
    
//    init(genericDoc : CloudantGenericDoc) {
//        self.id = genericDoc.id!
//        self.rev = genericDoc.rev!
//        self.type = genericDoc.type!
//        self.podcastDescription = genericDoc.podcastDescription!
//        self.broadcasters = genericDoc.broadcasters!
//        self.url = genericDoc.url!
//        self.participants = genericDoc.participants!
//    }
    
    enum CodingKeys : String,CodingKey {
        case id = "_id"
        case rev = "_rev"
        case type
        case name
        case podcastDescription = "description"
        case broadcasters
        case url = "urlAddress"
        case participants
    }
}

struct CloudantGenericDoc : Codable {
    let id : String?
    let rev : String?
    let type : String?
    //comment
    let timeStamp : String?
    let podcastID : String?
    let message : String?
    let userID : String?
    //podcast
    let name : String?
    let podcastDescription : String?
    let broadcasters : [String]?
    let url : String?
    let participants : [String]?
    
    enum CodingKeys : String,CodingKey {
        case id = "_id"
        case rev = "_rev"
        case type
        
        //comment
        case timeStamp
        case podcastID
        case message
        case userID
        //podcast
        case name
        case podcastDescription  = "description"
        case broadcasters
        case url = "urlAddress"
        case participants
    }
    
    
}

struct CloudantJsonRow : Codable{
    let id : String
    let key : String
    let value : CloudantRowValue
    let doc : CloudantGenericDoc
    
    enum CodingKeys : String,CodingKey {
        case id
        case key
        case value
        case doc
    }
}

struct FullCloudantResponse : Codable {
    let totalRows : Int
    let offset: Int
    let rows : [CloudantJsonRow]
    
    enum CodingKeys: String,CodingKey {
        case totalRows = "total_rows"
        case offset
        case rows
    }
}


