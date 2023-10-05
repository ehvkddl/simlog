//
//  AddDiaryViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit

class AddDiaryViewController: BaseViewController {
    
    let titleLabel = ["날씨", "기분", "식사", "수면", "할일", "사진", "한줄일기", "긴일기"]
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.configureLayout())
        view.backgroundColor = Constants.BaseColor.grayBackground
        view.showsVerticalScrollIndicator = false
        return view
    }()
    var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        configureSnapshot()
    }
    
    override func configureView() {
        view.backgroundColor = Constants.BaseColor.grayBackground
        
        [collectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
}

extension AddDiaryViewController {
    
    @objc private func closeButtonClicked() {
        dismiss(animated: true)
    }
    
}

extension AddDiaryViewController {
    
    func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(titleLabel, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<AddDiaryCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = self.titleLabel[indexPath.item]
            cell.addButtonClosure = {
                let vc = BedTimeViewController()
                vc.vm.sleep.value = Sleep(bedTime: 3600.0, wakeupTime: 28800.0)
                vc.saveButtonClosure = { bedTime, wakeupTime, sleepTime in
                    print(bedTime, wakeupTime, sleepTime)
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }

    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}
