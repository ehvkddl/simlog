//
//  TabBarController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/26.
//

import UIKit

enum GNBCategory: CaseIterable {
    case calendar
    case statistics
    case setting
    
    var vc: UIViewController {
        switch self {
        case .calendar: return UINavigationController(rootViewController: CalendarViewController())
        case .statistics: return UINavigationController(rootViewController: StatisticsViewController())
        case .setting: return UINavigationController(rootViewController: SettingViewController())
        }
    }
    
    var title: String {
        switch self {
        case .calendar: return "달력"
        case .statistics: return "통계"
        case .setting: return "설정"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .calendar: return UIImage(systemName: "calendar")
        case .statistics: return UIImage(systemName: "chart.bar")
        case .setting: return UIImage(systemName: "gearshape")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .calendar: return UIImage(systemName: "calendar")
        case .statistics: return UIImage(systemName: "chart.bar.fill")
        case .setting: return UIImage(systemName: "gearshape.fill")
        }
    }
}

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        designTabBar()
    }
    
    private func configureTabBar() {
        self.setViewControllers(GNBCategory.allCases.compactMap { $0.vc }, animated: true)
    }
    
    private func designTabBar() {
        self.tabBar.tintColor = UIColor.black
        
        if let items = self.tabBar.items {
            GNBCategory.allCases.enumerated().forEach { idx, item in
                items[idx].title = item.title
                items[idx].image = item.image
                items[idx].selectedImage = item.selectedImage
            }
        }
    }
    
}
