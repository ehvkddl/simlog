//
//  FSCalendarCustomCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/17.
//

import UIKit
import FSCalendar

class FSCalendarCustomCell: FSCalendarCell {
    
    var _isSelected = false
    
    let dayLabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = Constants.BaseColor.text
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 8
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let moodImage = {
        let img = UIImageView()
        img.image = UIImage(systemName: "circle.fill")
        img.tintColor = Constants.BaseColor.grayBackground
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        dayLabel.backgroundColor = .clear
        moodImage.tintColor = Constants.BaseColor.grayBackground
    }
    
    func configureCell() {
        [dayLabel, moodImage].forEach { contentView.addSubview($0) }
    }
    
    func setConstraints() {
        dayLabel.setContentHuggingPriority(.init(rawValue: 751), for: .vertical)
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(2)
            make.width.equalTo(30)
            make.centerX.equalTo(contentView)
        }
        
        moodImage.setContentHuggingPriority(.init(rawValue: 750), for: .vertical)
        moodImage.snp.makeConstraints { make in
            make.top.equalTo(dayLabel.snp.bottom)
            make.bottom.equalTo(contentView).inset(2)
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.85)
            make.height.equalTo(moodImage.snp.width).multipliedBy(1)
        }
    }
    
    func select() {
        _isSelected = true
        dayLabel.backgroundColor = Constants.BaseColor.ButtonBackground
    }
    
    func deselect() {
        _isSelected = false
        dayLabel.backgroundColor = .clear
    }
    
    func exist(mood: Int) {
        moodImage.tintColor = UIColor.moodColor(score: mood)
    }
    
}
