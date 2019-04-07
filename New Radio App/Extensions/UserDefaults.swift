//
//  UserDefaults.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 26/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritePodcastKey = "favoritePodcastKey"
    
    func savePodcasts() -> [Podcast]{
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else {return []}
     
                guard let savedPodcasts = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcast] else {return []}
         
        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savePodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.name != podcast.name
            
                //&& p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
    }

}

