//
//  DailyLogComponentAddButton.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/12.
//

import UIKit

class DailyLogComponentAddButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        var config = UIButton.Configuration.filled()
        
        config.baseForegroundColor = Constants.BaseColor.text
        config.baseBackgroundColor = Constants.BaseColor.ButtonBackground
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
        
        configuration = config

        contentMode = .scaleAspectFit
        clipsToBounds = true
        
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func photoButton() {
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
}
