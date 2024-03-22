//
//  SLSlider.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/26.
//

import UIKit

class SLSlider: UISlider {
    
    private var baseLayer = CALayer()
    private var thumbLabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    override func layoutIfNeeded() {
        createThumbLabel()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubview(thumbLabel)
        setup()
    }
 
    private func setup() {
        clear()
        createBaseLayer()
        createThumbLabel()
    }
 
    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
    }
    
    private func createBaseLayer() {
        baseLayer = getGradientBackground()
        baseLayer.frame = .init(x: 0,
                                y: 0,
                                width: frame.width,
                                height: frame.height)
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func createThumbLabel() {
        thumbLabel.text = String(Int(self.value))
        
        let trackRect = trackRect(forBounds: self.bounds)
        let thumbRect = thumbRect(forBounds: self.bounds, trackRect: trackRect, value: self.value)
        
        thumbLabel.snp.remakeConstraints() { make in
            make.centerX.equalTo(thumbRect.origin.x + self.frame.origin.x - 5)
            make.centerY.equalTo(self)
        }
    }
    
    func setLabelTextColor() {
        thumbLabel.textColor = .black
    }
    
}
