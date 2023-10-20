//
//  WeatherCollectionViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/19.
//

import UIKit

class WeatherTableViewCell: BaseTableViewCell {
    
    var tableViewWidth: CGFloat = 0
    var itemSize: CGFloat = 30
    var weathers: [WeatherType] = [] {
        didSet {
            weatherCollectionView.reloadData()
        }
    }
    
    lazy var weatherCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.description())
        
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    override func configureCell() {
        super.configureCell()
        
        [weatherCollectionView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        weatherCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(itemSize)
        }
    }
    
}

extension WeatherTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.description(), for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: weathers[indexPath.item].imageName)
        
        return cell
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 3
        
        return layout
    }
    
}
