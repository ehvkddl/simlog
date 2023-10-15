//
//  UISlider+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/09.
//

import UIKit

extension UISlider {

    func getThumbCenter() -> CGPoint {
        let trackRect : CGRect = self.trackRect(forBounds: self.bounds)
        let thumbRect : CGRect = self.thumbRect(forBounds: self.bounds, trackRect: trackRect, value: self.value)
        return CGPoint(x: thumbRect.origin.x + self.frame.origin.x - 5, y: self.frame.origin.y - 25)
    }
    
}
