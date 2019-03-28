//
//  CMTime.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String{
        
        if CMTimeGetSeconds(self).isNaN{
            return "--:--"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        //set format (01) for our label
        let timeFormatingString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatingString
    }
}
