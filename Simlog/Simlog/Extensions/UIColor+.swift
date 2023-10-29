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
        case 0...10: return Constants.BaseColor.SLRed
        case 11...21: return Constants.BaseColor.SLOrange
        case 22...32: return Constants.BaseColor.SLYellow
        case 33...43: return Constants.BaseColor.SLYellowgreen
        case 44...54: return Constants.BaseColor.SLGreen
        case 55...65: return Constants.BaseColor.SLBluegreen
        case 66...76: return Constants.BaseColor.SLMint
        case 77...87: return Constants.BaseColor.SLBlue
        case 88...100: return Constants.BaseColor.SLPurple
        default: return Constants.BaseColor.ButtonBackground
        }
    }
    
}
