//
//  MenuOption.swift
//  zurnaFourth
//
//  Created by Yavuz on 15.03.2019.
//  Copyright © 2019 Yavuz. All rights reserved.
//

enum MenuOption: Int,CustomStringConvertible{
    
    case Profile
    case Inbox
    case Notifications
    case Settings
    
    var description: String{
        switch self {
        case .Profile: return "Profile"
        case .Inbox: return "Inbox"
        case .Notifications: return "Notifications"
        case .Settings: return "Settings"
        }
    }
}
