//
//  NewStreakModel.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 20/2/24.
//

import Foundation
import UIKit

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
