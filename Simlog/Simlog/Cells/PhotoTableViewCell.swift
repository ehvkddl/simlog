//
//  PhotoTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/19.
//

import UIKit

class PhotoTableViewCell: BaseTableViewCell {
    
    let photoView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func configureCell() {
        super.configureCell()
        
        [photoView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        photoView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(10)
            make.size.equalTo(contentView.bounds.width)
            make.center.equalTo(contentView)
        }
    }
    
}
