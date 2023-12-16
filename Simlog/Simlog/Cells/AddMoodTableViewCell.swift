//
//  AddMoodTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddMoodTableViewCell: AddDailyLogBaseTableViewCell {
    
    var sliderValueChangedClosure: ((Int) -> Void)?
    
    let slider = {
        let slider = SLSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
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
        
        containerView.addSubview(slider)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).offset(-15)
            make.centerX.equalTo(containerView)
        }
    }
    
}

extension AddMoodTableViewCell {
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        slider.setLabelTextColor()
        slider.layoutIfNeeded()
        sliderValueChangedClosure?(Int(value))
    }
    
}
