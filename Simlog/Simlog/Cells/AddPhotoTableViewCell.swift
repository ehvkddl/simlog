//
//  AddPhotoTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import UIKit

class AddPhotoTableViewCell: AddDailyLogBaseTableViewCell {
    
    var photoButtonClosure: (() -> Void)?
    
    let photoButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "photo"), for: .normal)
        btn.tintColor = Constants.BaseColor.accent
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.contentMode = .scaleAspectFill
        btn.clipsToBounds = true
        return btn
    }()
    
    override func configureCell() {
        super.configureCell()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sendPhoto),
                                               name: Notification.Name("sendPhoto"),
                                               object : nil)
        
        photoButton.addTarget(self, action: #selector(photoButtonClicked), for: .touchUpInside)
        
        containerView.addSubview(photoButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(15)
            make.height.equalTo(photoButton.snp.width).multipliedBy(0.75)
        }
    }
    
}

extension AddPhotoTableViewCell {
    
    @objc func photoButtonClicked() {
        photoButtonClosure?()
    }
    
    @objc func sendPhoto(notification : NSNotification) {
        if let image = notification.object as? UIImage {
            DispatchQueue.main.async {
                self.photoButton.setImage(image, for: .normal)
            }
        }
    }
    
}
