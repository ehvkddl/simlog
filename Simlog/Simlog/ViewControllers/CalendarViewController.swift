//
//  ViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/25.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {

    let vm = CalendarViewModel()
    
    lazy var calendar = {
        let calendar = FSCalendar()
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.headerHeight = 0
        
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = .systemGray
        
        calendar.appearance.titleDefaultColor = Constants.BaseColor.text
        calendar.appearance.titleSelectionColor = Constants.BaseColor.reverseText
        
        return calendar
    }()
    
    let addButton = {
        let btn = UIButton()
        
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.baseForegroundColor = Constants.BaseColor.reverseText
        config.baseBackgroundColor = Constants.BaseColor.accent
        btn.configuration = config
        
        btn.layer.cornerRadius = btn.frame.width * 0.5
        btn.clipsToBounds = true
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.title.bind { str in
            self.title = str
        }
        vm.setCurrentPageTitle(date: calendar.currentPage)
    }

    override func configureView() {
        super.configureView()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [calendar, addButton].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view).multipliedBy(0.5)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.size.equalTo(50)
        }
    }
    
}

extension CalendarViewController {
    
    @objc private func addButtonClicked() {
        let vc = UINavigationController(rootViewController: AddDailyLogViewController())
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        vm.setCurrentPageTitle(date: calendar.currentPage)
    }
    
}
