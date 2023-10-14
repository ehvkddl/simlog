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
    
    override func configureCell() {
        super.configureCell()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [addButton].forEach { containerView.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(15)
        }
    }
    
    func apply(type: CellType, title: String, buttonTitle: String) {
        super.apply(type: type, title: title)
        
        addButton.setTitle(buttonTitle, for: .normal)
    }
    
}

extension AddDailyLogTableViewCell {
    
    @objc func addButtonClicked() {
        self.addButtonClosure?()
    }
    
}
