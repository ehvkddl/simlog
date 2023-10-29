//
//  UIView+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/09.
//

import UIKit

extension UIView {
    
    func getGradientBackground() -> CALayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x:0.0, y:0.5)
        gradient.endPoint = CGPoint(x:1.0, y:0.5)
        gradient.colors = [
            Constants.BaseColor.SLRed.cgColor,
            Constants.BaseColor.SLOrange.cgColor,
            Constants.BaseColor.SLYellow.cgColor,
            Constants.BaseColor.SLYellowgreen.cgColor,
            Constants.BaseColor.SLGreen.cgColor,
            Constants.BaseColor.SLBluegreen.cgColor,
            Constants.BaseColor.SLMint.cgColor,
            Constants.BaseColor.SLBlue.cgColor,
            Constants.BaseColor.SLPurple.cgColor
        ]
        
        return gradient
    }
    
}


