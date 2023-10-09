//
//  AddMoodTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddMoodTableViewCell: AddDailyLogBaseTableViewCell {
    
    let slider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        return slider
    }()
    
    lazy var sliderBackgroundView = {
        let view = UIView()
        view.layer.addSublayer(getGradientBackground())
        view.clipsToBounds = true
        return view
    }()
    
    let thumbLabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()

    override func configureCell() {
        super.configureCell()
        
        slider.addTarget(self, action: #selector(sliderValueChanged),for: .valueChanged)
        
        [sliderBackgroundView, slider].forEach { containerView.addSubview($0) }
        slider.addSubview(thumbLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).offset(-15)
            make.centerX.equalTo(containerView)
        }
        
        sliderBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(slider)
        }
        
        thumbLabel.snp.remakeConstraints { make in
            make.center.equalTo(slider.getThumbCenter())
        }
    }
    
}

extension AddMoodTableViewCell {
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value

        thumbLabel.text = String(Int(value))
        thumbLabel.snp.remakeConstraints { make in
            make.center.equalTo(slider.getThumbCenter())
        }
    }
    
}
