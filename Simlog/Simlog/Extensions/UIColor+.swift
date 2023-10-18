//
//  UIColor+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/09.
//

import UIKit

extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static func moodColor(score: Int) -> UIColor {
        switch score {
        case 0...20: return UIColor(hexCode: "E75C56")
        case 21...40: return UIColor(hexCode: "F6F96E")
        case 41...60: return UIColor(hexCode: "85F675")
        case 61...80: return UIColor(hexCode: "6F90F1")
        case 81...100: return UIColor(hexCode: "5F90F1")
        default: return Constants.BaseColor.ButtonBackground
        }
    }
    
}
