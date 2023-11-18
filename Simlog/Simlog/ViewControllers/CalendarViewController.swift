//
//  ViewController.swift
//  Simlog
//
//  Created by do hee kim on 2023/09/25.
//

import UIKit
import FSCalendar
import Loaf

class CalendarViewController: BaseViewController {

    let vm = CalendarViewModel()
    
    var selectedLog: DailyLog?
    
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
        dailyLogView.editButton.addTarget(self, action: #selector(editDailyLogClicked), for: .touchUpInside)
        dailyLogView.deleteButton.addTarget(self, action: #selector(deleteDailyLogClicked), for: .touchUpInside)
        
        [scrollView, addButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [calendar, dailyLogView].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view)
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
            make.bottom.equalTo(contentView.snp.bottom).inset(50)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.greaterThanOrEqualTo(100)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.size.equalTo(50)
        }
    }
    
}

extension CalendarViewController {
    
    @objc private func addButtonClicked() {
        let dateStr = AppDateFormatter.shared.toString(date: Date(), type: .year)
        guard let date = AppDateFormatter.shared.toDate(date: dateStr, type: .year) else { return }
        
        guard let dailyLog = vm.fetchDailyLog(on: date) else {
            presentAddDailyLogView(date: date)
            return
        }
        
        Loaf("오늘의 일기는 이미 작성했어요.", state: .info, location: .top, sender: self).show()
        setDailyLog(dailyLog: dailyLog)
    }
    
    }
    
    private func presentAddDailyLogView(date: Date) {
        let vc = AddDailyLogViewController()
        vc.vm.dailylog.value.date = date
        
        vc.saveButtonClickedClosure = {
            self.dailyLogView.isHidden = true
            self.calendar.reloadData()
            self.scrollToTop()
        }
        

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        
        present(nav, animated: true)
    }
    
    private func setDailyLog(dailyLog log: DailyLog) {
        dailyLogView.isHidden = false
        dailyLogView.log = log
        dailyLogView.setValue()
    }
    
    @objc private func editDailyLogClicked() {
    }
    
    @objc private func deleteDailyLogClicked() {
        guard let selectedLog else { return }
        showAlert(
            title: AppDateFormatter.shared.toString(date: selectedLog.date, type: .year),
            message: "정말로 일기를 삭제하시겠어요?"
        ) {
            self.vm.deleteDailyLog(selectedLog)
            self.dailyLogView.isHidden = true
            self.calendar.reloadData()
        }
    }
    
    private func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
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
        
        switch Calendar.compareToday(to: date) {
        case .orderedDescending, .orderedSame:
            guard let log = vm.fetchDailyLog(on: date) else {
                presentAddDailyLogView(date: date)
                dailyLogView.isHidden = true
                selectedLog = nil
                scrollToTop()
                return
            }
            
            setDailyLog(dailyLog: log)
            selectedLog = log
            
        default:
            Loaf("미래는 일기를 작성할 수 없어요.", state: .info, location: .top, sender: self).show()
            break
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        vm.setCurrentPageTitle(date: calendar.currentPage)
        scrollToTop()
        dailyLogView.isHidden = true
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: FSCalendarCustomCell.description(), for: date, at: position) as? FSCalendarCustomCell else { return FSCalendarCell() }
        
        switch Calendar.compareToday(to: date) {
        case .orderedDescending:
            cell.dayLabel.text = AppDateFormatter.shared.toString(date: date, type: .day)
        case .orderedSame:
            cell.dayLabel.text = "오늘"
        case .orderedAscending:
            cell.dayLabel.text = AppDateFormatter.shared.toString(date: date, type: .day)
            cell.moodImage.image = UIImage(systemName: "circle.dotted")
        default: break
        }
        
        guard let log = vm.fetchDailyLog(on: date) else { return cell }
        cell.exist(mood: log.mood!)
        
        return cell
    }
    
}
