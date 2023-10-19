//
//  BaseView.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/18.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() { }

    func setConstraints() { }

}
