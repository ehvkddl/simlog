//
//  LabelTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/19.
//

import UIKit

class LabelTableViewCell: BaseTableViewCell {
    
    let label = {
        let lbl = PaddingLabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func configureCell() {
        super.configureCell()
        
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
            label.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            label.textColor = .systemGray
            label.font = UIFont.systemFont(ofSize: 13)
        case .diary:
            label.padding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            label.backgroundColor = Constants.BaseColor.cellBackground
        default: break
        }
    }
    
    func clear() {
        label.textColor = Constants.BaseColor.text
        label.font = UIFont.systemFont(ofSize: 15)
        label.backgroundColor = .clear
    }
    
}
