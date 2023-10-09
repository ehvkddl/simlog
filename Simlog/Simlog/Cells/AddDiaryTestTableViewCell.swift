//
//  AddDiaryTestTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/06.
//

import UIKit

class AddDiaryTestTableViewCell: BaseTableViewCell {
    
    var cellType: CellType?
    
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
    
    let contentsView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    lazy var addButton = {
        let btn = UIButton()
        
        var config = UIButton.Configuration.filled()
        
        config.baseForegroundColor = Constants.BaseColor.text
        config.baseBackgroundColor = Constants.BaseColor.ButtonBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
        
        btn.configuration = config
        btn.layer.cornerRadius = Constants.cornerRadius
        return btn
    }()
    
    override func configureCell() {
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [containerView].forEach { contentView.addSubview($0) }
        [titleLabel, contentsView, addButton].forEach { containerView.addSubview($0) }
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
        
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(contentsView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(15)
        }
    }
    
}

extension AddDiaryTestTableViewCell {
    
    func setContent(by type: CellType) {
        switch type {
        case .mood:
            break
        case .weather:
            break
        case .meal:
            break
        case .sleep:
            break
        case .todo:
            break
        case .photo:
            break
        case .diary:
            break
        }
    }
    
}

extension AddDiaryTestTableViewCell {
    
    @objc func addButtonClicked() {
        self.addButtonClosure?()
    }
    
}
