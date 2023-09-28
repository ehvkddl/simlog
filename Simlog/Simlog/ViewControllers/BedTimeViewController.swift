//
//  BedTimeViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/28.
//

import UIKit
import HGCircularSlider

class BedTimeViewController: BaseViewController {

    lazy var backgroundView = {
        let view = UIImageView()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)
        return view
    }()
    
    let contentsView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.containerBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    let closeButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")
        config.baseForegroundColor = Constants.BaseColor.accent
        btn.configuration = config
        return btn
    }()
    
    lazy var rangeCircularSlider = {
        let slider = RangeCircularSlider()
        slider.backgroundColor = .clear
        slider.startThumbImage = UIImage(systemName: "moon.zzz.fill")?.withTintColor(Constants.BaseColor.background)
        slider.endThumbImage = UIImage(systemName: "sun.max.fill")?.withTintColor(Constants.BaseColor.background)
        slider.backtrackLineWidth = 40.0
        slider.lineWidth = 40.0
        slider.trackColor = Constants.BaseColor.grayBackground
        slider.trackFillColor = Constants.BaseColor.accent
        slider.diskColor = .clear
        slider.diskFillColor = Constants.BaseColor.grayBackground
        return slider
    }()
    
    let clockImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawTicks(count: 60)
    }
    
    override func configureView() {
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        [backgroundView, contentsView].forEach { view.addSubview($0) }
        [closeButton, rangeCircularSlider, clockImageView].forEach { contentsView.addSubview($0) }
    }
    
    override func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentsView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentsView).inset(10)
            make.size.equalTo(30)
        }
        
        rangeCircularSlider.snp.makeConstraints { make in
            make.center.equalTo(contentsView)
            make.size.equalTo(contentsView.snp.width).multipliedBy(0.95)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.center.equalTo(contentsView)
            make.size.equalTo(contentsView.snp.width).multipliedBy(0.57)
        }
    }
    
}

extension BedTimeViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}

extension BedTimeViewController {
    
    private func drawTicks(count: Int) {
        let radius = clockImageView.frame.width * 0.5
        var rotationInDegrees: CGFloat = 0

        for i in 0 ..< count {
            let tick = i % 5 == 0 ? createTick(height: 10.0) : createTick(height: 5.0)

            let x = CGFloat(Float(clockImageView.center.x) + Float(radius) * cosf(2 * Float(i) * Float(Double.pi) / Float(count) - Float(Double.pi) / 2))
            let y = CGFloat(Float(clockImageView.center.y) + Float(radius) * sinf(2 * Float(i) * Float(Double.pi) / Float(count) - Float(Double.pi) / 2))

            tick.center = CGPoint(x: x, y: y)
            tick.transform = CGAffineTransform.identity.rotated(by: rotationInDegrees * .pi / 180.0)
            clockImageView.addSubview(tick)

            rotationInDegrees = rotationInDegrees + (360.0 / CGFloat(count))
        }
    }

    private func createTick(height: Double) -> UIView {
        let tick = UIView(frame: CGRect(x: 0, y: 0, width: 1.5, height: height))
        tick.backgroundColor = Constants.BaseColor.tick

        return tick
    }
    
}
