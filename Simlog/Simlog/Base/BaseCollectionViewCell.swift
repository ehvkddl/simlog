//
//  BaseCollectionViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() { }
    
    func setConstraints() { }
    
}
