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
        
        calendar.collectionView.register(FSCalendarCustomCell.self, forCellWithReuseIdentifier: FSCalendarCustomCell.description())
        
        calendar.headerHeight = 0
        
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.appearance.weekdayTextColor = .systemGray
        
        calendar.appearance.titleDefaultColor = UIColor.clear
        calendar.appearance.titleSelectionColor = UIColor.clear
        calendar.appearance.titleTodayColor = UIColor.clear
        calendar.appearance.selectionColor = UIColor.clear
        calendar.appearance.todayColor = UIColor.clear
        
        calendar.placeholderType = .none
        
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
        calendar.visibleCells()
            .map { $0 as? FSCalendarCustomCell }
            .compactMap { $0 }
            .filter { $0._isSelected }
            .forEach { customCell in
                customCell.deselect()
            }
        
        if let cell = calendar.cell(for:date, at: monthPosition) as? FSCalendarCustomCell {
            cell.select()
        }
        
        guard let log = vm.fetchDailyLog(on: date) else {
            dailyLogView.isHidden = true
            presentAddDailyLogView(date: date)
            return
        }
        
        setDailyLog(dailyLog: log)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        vm.setCurrentPageTitle(date: calendar.currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.description(), for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
        let cellDay = AppDateFormatter.shared.toString(date: date, type: .year)
        let today = AppDateFormatter.shared.toString(date: Date(), type: .year)
        
        switch cellDay {
        case today: cell.dayLabel.text = "오늘"
        default: cell.dayLabel.text = AppDateFormatter.shared.toString(date: date, type: .day)
        }
        
        guard let log = vm.fetchDailyLog(on: date) else { return cell }
        cell.exist(mood: log.mood!)
        
        return cell
    }
    
}
