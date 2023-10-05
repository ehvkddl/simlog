//
//  AddDiaryTestTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddDiaryTestTableViewCell: BaseTableViewCell {
    
    var addButtonClosure: (() -> Void)?

    let containerView = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.containerBackground
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    let titleLabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return lbl
    }()
    
    let addButton = {
        let btn = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "수면시간 기록하기"
        
        config.baseForegroundColor = Constants.BaseColor.text
        config.baseBackgroundColor = Constants.BaseColor.ButtonBackground
        
        btn.configuration = config
        btn.layer.cornerRadius = Constants.cornerRadius
        return btn
    }()
    
    override func configureCell() {
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [containerView].forEach { contentView.addSubview($0) }
        [titleLabel, addButton].forEach { containerView.addSubview($0) }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).inset(15)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(15)
        }
    }
    
}

extension AddDiaryTestTableViewCell {
    
    @objc func addButtonClicked() {
        self.addButtonClosure?()
    }
    
}
