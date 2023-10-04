//
//  AddDiaryCollectionViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/27.
//

import UIKit

class AddDiaryCollectionViewCell: BaseCollectionViewCell {
    
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
    
    override func configureCell() {
        [containerView].forEach { contentView.addSubview($0) }
        [titleLabel].forEach { containerView.addSubview($0) }
    }
    
    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).inset(15)
        }
    }
}
