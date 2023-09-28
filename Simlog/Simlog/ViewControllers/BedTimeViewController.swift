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
        slider.startThumbImage = UIImage(systemName: "moon.zzz.fill")?.withTintColor(.white)
        slider.endThumbImage = UIImage(systemName: "sun.max.fill")?.withTintColor(.white)
        slider.backtrackLineWidth = 35.0
        slider.lineWidth = 35.0
        slider.trackFillColor = .black
        
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        [backgroundView, contentsView].forEach { view.addSubview($0) }
        [closeButton, rangeCircularSlider].forEach { contentsView.addSubview($0) }
        
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
            make.size.equalTo(300)
        }
    }
    
}

extension BedTimeViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}
