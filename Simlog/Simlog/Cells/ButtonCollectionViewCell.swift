//
//  ButtonCollectionViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/10.
//

import UIKit

class ButtonCollectionViewCell: BaseCollectionViewCell {
    
    let buttonImage = {
        let view = UIImageView()
        return view
    }()
    
    let buttonLabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    override func configureCell() {
        [buttonImage, buttonLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        buttonImage.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(contentView.snp.width)
        }

        buttonLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonImage.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(contentView).inset(2)
            make.bottom.equalTo(contentView)
        }
    }
    
}
