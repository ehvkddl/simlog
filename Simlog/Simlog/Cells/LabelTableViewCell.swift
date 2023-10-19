//
//  LabelTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/19.
//

import UIKit

class LabelTableViewCell: BaseTableViewCell {
    
    let label = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func configureCell() {
        [label].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(5)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(5)
        }
    }
}

extension LabelTableViewCell {
    
    func configureCell(type: CellType) {
        clear()
        
        switch type {
        case .sleep:
            label.textColor = .systemGray
            label.font = UIFont.systemFont(ofSize: 13)
        case .diary:
            label.backgroundColor = Constants.BaseColor.grayBackground
        default: break
        }
    }
    
    func clear() {
        label.textColor = Constants.BaseColor.text
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .clear
    }
    
}
