//
//  AddDailyLogBaseTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/09.
//

import UIKit

class AddDailyLogBaseTableViewCell: BaseTableViewCell {
    
    var cellType: CellType?
    
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
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.verticalEdges.equalTo(contentView).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).inset(15)
            make.horizontalEdges.equalTo(containerView).inset(15)
        }
    }
    
}
