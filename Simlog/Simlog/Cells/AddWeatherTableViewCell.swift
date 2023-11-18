//
//  AddWeatherTableViewCell.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/09.
//

import UIKit

class AddWeatherTableViewCell: AddDailyLogBaseTableViewCell {

    let vm = WeatherViewModel()
    
    var cellButtonClickedClosure: (([WeatherType]) -> Void)?
    
    var buttons = [
        ButtonItem(type: .clear, imageName: "sun", label: "맑음", isSelect: false),
        ButtonItem(type: .cloud, imageName: "cloud", label: "흐림", isSelect: false),
        ButtonItem(type: .rain, imageName: "rain", label: "비", isSelect: false),
        ButtonItem(type: .snow, imageName: "snow", label: "눈", isSelect: false),
        ButtonItem(type: .thunder, imageName: "thunder", label: "천둥・번개", isSelect: false),
        ButtonItem(type: .wind, imageName: "wind", label: "바람", isSelect: false)
    ]
    
    lazy var buttonCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = Constants.BaseColor.containerBackground
        return collectionView
    }()
    var dataSource: UICollectionViewDiffableDataSource<Int, ButtonItem>!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCollectionViewCell()
        updateSnapshot()
        
        vm.weather.bind { [self] weathers in
            updateSnapshot()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureCell() {
        super.configureCell()
        
        [buttonCollectionView].forEach { containerView.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        buttonCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(containerView).inset(20)
            make.height.equalTo(containerView.snp.width).multipliedBy(0.23 * 1.3 * 2)
            make.bottom.equalTo(containerView.snp.bottom).inset(15)
            make.centerX.equalTo(containerView)
        }
    }
    
}

extension AddWeatherTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        buttons[indexPath.item].isSelect.toggle()
        
        let button = buttons[indexPath.item]
        vm.buttonClicked(type: button.type, isSelect: button.isSelect)
        
        cellButtonClickedClosure?(Array(vm.weather.value))
    }
    
}

extension AddWeatherTableViewCell {
    
    private func configureCollectionViewCell() {
        let cellRegistration = UICollectionView.CellRegistration<ButtonCollectionViewCell, ButtonItem> { cell, indexPath, itemIdentifier in
            cell.buttonImage.image = UIImage(named: itemIdentifier.imageName)
            cell.buttonImage.alpha = itemIdentifier.isSelect ? 1.0 : 0.4
            cell.buttonLabel.text = itemIdentifier.label
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: buttonCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    private func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/4 * 1.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 4)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(22)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 14
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ButtonItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(buttons, toSection: 0)
        dataSource.apply(snapshot)
    }
    
}
