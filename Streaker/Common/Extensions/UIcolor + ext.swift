//
//  UIcolor + ext.swift
//  Streaker
//
//  Created by Viacheslav Andriienko on 11/25/23.
//

import Foundation

import Foundation
import UIKit

extension UIColor {
    enum ColorType {
        case streakerGrey
      
    }
    
    static func theme(_ colorType: ColorType) -> UIColor {
        var color: UIColor?
        
        switch colorType {
        case .streakerGrey:
            color = UIColor(named: "streakerGrey")
        }
        
        guard let color = color else {
            fatalError("Color \(colorType) not found")
        }
        
        return color
    }
}
