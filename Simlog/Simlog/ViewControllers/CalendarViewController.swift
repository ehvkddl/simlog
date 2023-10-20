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
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let contentView = UIView()
    
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
    
    let dailyLogView = {
        let view = DailyLogView()
        view.isHidden = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.fetch()
        
        vm.title.bind { str in
            self.title = str
        }
        vm.setCurrentPageTitle(date: calendar.currentPage)
    }

    override func configureView() {
        super.configureView()
        
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        [scrollView, addButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [calendar, dailyLogView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.93)
            make.height.equalTo(450)
            make.centerX.equalTo(contentView)
        }
        
        dailyLogView.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom)
            make.width.equalTo(calendar)
            make.bottom.equalTo(contentView.snp.bottom)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.size.equalTo(50)
        }
    }
    
}

extension CalendarViewController {
    
    @objc private func addButtonClicked() {
        presentAddDailyLogView(date: Date())
    }
    
    private func presentAddDailyLogView(date: Date) {
        let vc = AddDailyLogViewController()
        vc.vm.dailylog.value.date = date

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        
        present(nav, animated: true)
    }
    
    private func setDailyLog(dailyLog log: DailyLog) {
        dailyLogView.isHidden = false
        dailyLogView.log = log
        dailyLogView.setValue()
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
        dailyLogView.isHidden = true
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
