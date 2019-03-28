//
//  UIApplication.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit

extension UIApplication{
    static func mainTabController() -> MainTabBarController?{
        //let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
       return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
