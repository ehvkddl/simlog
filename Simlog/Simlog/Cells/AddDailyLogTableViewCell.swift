//
//  AddDiaryTestTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddDailyLogTableViewCell: AddDailyLogBaseTableViewCell {
    
    var addButtonClosure: (() -> Void)?
    
    lazy var contentsView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    let addButton = {
        let btn = DailyLogComponentAddButton()
        return btn
    }()
    
}

extension AddDailyLogTableViewCell {
    
    func setContent(by type: CellType) {
        switch type {
        case .meal:
            break
        case .sleep, .diary:
            addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
            
            [addButton].forEach { containerView.addSubview($0) }
            
            addButton.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.horizontalEdges.equalTo(containerView).inset(20)
                make.bottom.equalTo(containerView.snp.bottom).inset(15)
            }
        case .todo:
            break
        case .photo:
            break
        default: break
        }
    }
    
}

extension AddDailyLogTableViewCell {
    
    @objc func addButtonClicked() {
        self.addButtonClosure?()
    }
    
}
