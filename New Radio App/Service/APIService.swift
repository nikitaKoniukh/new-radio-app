//
//  APIService.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    //singleton
    static let shared = APIService()
    
    func fetchPodcast(callback: @escaping ([Podcast]) -> ()) {
        let url = URL(string: "https://87e906d3-cf6a-4687-be56-4e3698885873-bluemix.cloudant.com/demo/_all_docs?include_docs=true")!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            guard let d = data else {return}
            
            let fullResponse = try! JSONDecoder().decode(FullCloudantResponse.self, from: d)
            
            let rowsArr = fullResponse.rows
            
            var results = [Podcast]()
            
            for row in rowsArr {
                if row.doc.type == "podcast" {
                    let podcast = Podcast.from(cloudantGenericDocument: row.doc)
                    results.append(podcast!)
                }
            }
            DispatchQueue.main.async {
                callback(results)
            }
            
            
        }.resume()
    }
    
    
}
    //PARSING ONE EPISODE
    
//    func fetchPodcast(competionHandler: @escaping ([Podcast])->()){
//        let url = "https://87e906d3-cf6a-4687-be56-4e3698885873-bluemix.cloudant.com/demo/e2c13cade2cf5088e30786e248b14515"
//        Alamofire.request(url).responseData { (dataResponse) in
//            if let err = dataResponse.error{
//                print("Failed to connect", err)
//                return
//            }
//            guard let data = dataResponse.data else {return}
//
//            do {
//                let result = try
//                    JSONDecoder().decode(Podcast.self, from: data)
//                    competionHandler([result])
////                self.podcasts = [result]
////                self.tableView.reloadData()
//            }catch let decodeErr{
//                print("Failed to decode", decodeErr)
//            }
//        }
//    }
//}



// OPTION TO PARSE WHOLE JSON FROM CLOUDANT


//func fetchPodcast(competionHandler: @escaping ([Podcast])->()){
//    let url = URL(string: "https://87e906d3-cf6a-4687-be56-4e3698885873-bluemix.cloudant.com/demo/_all_docs?include_docs=true")!
//
//    let session = URLSession(configuration: .default)
//
//    session.dataTask(with: url) { (data, res, err) in
//
//        if let err = err{
//            print(err)
//            return
//        }
//
//        guard let d = data else {return}
//
//        guard let json = try! JSONSerialization.jsonObject(with: d, options: []) as? Json else {return}
//
//        var podcastArray = [Podcast]()
//
//        let j = json as Json
//        let rows = j["rows"] as? Json
//        print(rows)
//        let doc = rows!["doc"] as! [Json]
//
//        for pod in doc{
//            let pName = pod["name"] as! String
//            print(pName)
//
//            let podcast = Podcast(name: pName, myDescription: "", urlAddress: "")
//            print(podcast)
//            podcastArray.append(podcast)
//        }
//
//
//        }.resume()
//}


