//
//  ImageCollectionViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/19.
//

import UIKit

class ImageCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = {
        let view = UIImageView()
        return view
    }()
    
    override func configureCell() {
        [imageView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
}
