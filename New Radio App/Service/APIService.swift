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
    
    func fetchPodcast( callback: @escaping ([Podcast]) -> ()) {
        let url = URL(string: "https://87e906d3-cf6a-4687-be56-4e3698885873-bluemix.cloudant.com/demo/_all_docs?include_docs=true")!
        
       // let searchName = ["name": searchText]
        
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
