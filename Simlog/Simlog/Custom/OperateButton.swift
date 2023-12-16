//
//  OperateButton.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/23.
//

import UIKit

class OperateButton: UIButton {
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.image = image
        config.baseForegroundColor = Constants.BaseColor.ButtonBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.buttonSize = .small
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
