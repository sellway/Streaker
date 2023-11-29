//
//  ProfileModel.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/26/23.
//

import Foundation
import UIKit.UIImage

enum ProfileModel: CaseIterable {
    case newStreak
    case myStreaks
    case howItWorks
    case pauseAll
    case sendFeadback
    case settings
    
    var title: String {
        switch self {
       
        case .newStreak:
            return "add_new_st".localized()
        case .myStreaks:
            return "my_streaks".localized()
        case .howItWorks:
            return "how_it_works".localized()
        case .pauseAll:
            return "pause_all".localized()
        case .sendFeadback:
            return "send_Feadback".localized()
        case .settings:
            return "settings".localized()
        }
    }
    
    var image: UIImage {
        switch self {
      
        case .newStreak:
            return .theme(.newStrake)
        case .myStreaks:
            return .theme(.myStreake)
        case .howItWorks:
            return .theme(.howItWorks)
        case .pauseAll:
            return .theme(.pauseAll)
        case .sendFeadback:
            return .theme(.sendFeadback)
        case .settings:
            return .theme(.settings)
        }
    }
}


enum NewStreakModel: CaseIterable {
    case esential
    case Morning
    case beter
    case healthy
    case Happines
    case stay
    case Learn
    case personal
    case relationShip
    
    var title: String {
        switch self {
            
        case .esential:
            return "Essential habits"
        case .Morning:
            return "Morning habits"
        case .beter:
            return "Better sleep"
        case .healthy:
            return "Healthy and fit body"
        case .Happines:
            return "Happiness"
        case .stay:
            return "Stay focused"
        case .Learn:
            return "Learn & create "
        case .personal:
            return "Personal growth"
        case .relationShip:
            return "Relationships"
        }
    }
    
    var image: UIImage {
        switch self {
      
        
        case .esential:
            return .theme(.esential)
        case .Morning:
            return .theme(.Morning)
        case .beter:
            return .theme(.beter)
        case .healthy:
            return .theme(.healthy)
        case .Happines:
            return .theme(.Happines)
        case .stay:
            return .theme(.stay)
        case .Learn:
            return .theme(.Learn)
        case .personal:
            return .theme(.personal)
        case .relationShip:
            return .theme(.relationShip)
        }
    }
}
