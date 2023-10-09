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
        print(bounds)
        gradient.startPoint = CGPoint(x:0.0, y:0.5)
        gradient.endPoint = CGPoint(x:1.0, y:0.5)
        gradient.colors = [
            UIColor(hexCode: "E75C56").cgColor,
            UIColor(hexCode: "F6F96E").cgColor,
            UIColor(hexCode: "85F675").cgColor,
            UIColor(hexCode: "5F90F1").cgColor
        ]
        
        return gradient
    }
    
}


