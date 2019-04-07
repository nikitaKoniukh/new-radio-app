//
//  UserDefaultsFeedback.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 07/04/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let feedbackPodcastKey = "feedbackPodcastKey"
    
    func saveFeedback() -> [Podcast]{
        
        guard let savedPodcastData = UserDefaults.standard.data(forKey: UserDefaults.feedbackPodcastKey) else {return []}
        
        guard let savedFeedbacks = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastData) as? [Podcast] else {return []}
        
        return savedFeedbacks
    }
    
    func deleteFeedback(podcast: Podcast) {
        let podcasts = saveFeedback()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.name != podcast.name
            //&& p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.feedbackPodcastKey)
    }
    
}
