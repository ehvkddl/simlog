//
//  DailyLogView.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/18.
//

import UIKit

class DailyLogView: BaseView {
    
    let padding = 15
    
    var logComponentType: [CellType] = []
    var log: DailyLog?
    
    let dateLabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.BaseColor.text
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let moodColor = {
        let view = UIImageView()
        return view
    }()
    
    let separator = {
        let view = UIView()
        view.backgroundColor = Constants.BaseColor.cellBackground
        return view
    }()
    
    lazy var logTableView = {
        let view = ResizedTableView()
        
        view.dataSource = self
        
        view.register(cellType: WeatherTableViewCell.self)
        view.register(cellType: LabelTableViewCell.self)
        view.register(cellType: PhotoTableViewCell.self)
        
        view.rowHeight = UITableView.automaticDimension
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        
        view.allowsSelection = false
        
        return view
    }()
    
    let editButton = OperateButton(image: UIImage(systemName: "square.and.pencil"))
    
    let deleteButton = OperateButton(image: UIImage(systemName: "trash"))
    
    override func configureView() {
        logTableView.reloadDataWithCompletion { [unowned self] in
            let tableViewHeight = logTableView.contentSize.height
            
            logTableView.snp.remakeConstraints { make in
                make.top.equalTo(dateLabel)
                make.leading.equalTo(separator.snp.trailing).offset(15)
                make.trailing.equalTo(self).inset(padding)
                make.bottom.equalTo(separator)
                make.height.equalTo(tableViewHeight < 100 ? 100 : tableViewHeight)
            }
        }
        
        [dateLabel, moodColor, separator, logTableView, editButton, deleteButton].forEach { addSubview($0) }
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).inset(padding)
            make.width.equalTo(40)
        }

        moodColor.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.width.equalTo(dateLabel)
            make.height.equalTo(15)
            make.centerX.equalTo(dateLabel)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(self).inset(padding)
            make.leading.equalTo(dateLabel.snp.trailing).offset(15)
            make.width.equalTo(0.3)
        }

        logTableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.leading.equalTo(separator.snp.trailing).offset(15)
            make.trailing.equalTo(self).inset(padding)
            make.bottom.equalTo(separator)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(10)
            make.leading.equalTo(dateLabel.snp.leading)
            make.bottom.equalTo(self).inset(padding)
            make.size.equalTo(25)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton)
            make.leading.equalTo(editButton.snp.trailing).offset(10)
            make.bottom.equalTo(editButton)
            make.size.equalTo(25)
        }
    }
    
}

extension DailyLogView {
    
    func setValue() {
        guard let log = self.log else { return }
        
        dateLabel.text = AppDateFormatter.shared.toString(date: log.date, locale: "ko_KR", type: .dayWithWeek)
        moodColor.backgroundColor = UIColor.moodColor(score: log.mood ?? -1)
        
        logComponentType.removeAll(keepingCapacity: true)
        
        if let weathers = log.weather, !weathers.isEmpty {
            logComponentType.append(.weather)
        }
        
        if log.sleep != nil {
            logComponentType.append(.sleep)
        }
        
        if let photos = log.photo, !photos.isEmpty {
            logComponentType.append(.photo)
        }
        
        if log.diary != nil {
            logComponentType.append(.diary)
        }
        
        logTableView.reloadData()
    }
    
}

extension DailyLogView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logComponentType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let log = self.log else { return UITableViewCell() }
        let cellType = logComponentType[indexPath.row]

        switch cellType {
        case .mood:
            let cell = tableView.dequeueReusableCell(withClass: AddMoodTableViewCell.self, for: indexPath)
            return cell

        case .weather:
            let cell = tableView.dequeueReusableCell(withClass: WeatherTableViewCell.self, for: indexPath)
            
            guard let weathers = log.weather else { return UITableViewCell() }
            cell.weathers = weathers
            
            return cell

        case .sleep:
            let cell = tableView.dequeueReusableCell(withClass: LabelTableViewCell.self, for: indexPath)
            
            guard let sleep = log.sleep else { return UITableViewCell() }
            
            let bedTime = Date(timeIntervalSinceReferenceDate: sleep.bedTime)
            let bedTimeStr = AppDateFormatter.shared.toString(date: bedTime, timeZone: "UTC", type: .timeWithMeridiem)
            
            let wakeTime = Date(timeIntervalSinceReferenceDate: sleep.wakeupTime)
            let wakeTimeStr = AppDateFormatter.shared.toString(date: wakeTime, timeZone: "UTC", type: .timeWithMeridiem)
            
            let duration = Date(timeIntervalSinceReferenceDate: sleep.sleepTime)
            let durationStr = AppDateFormatter.shared.toString(date: duration, timeZone: "UTC", type: .timeWithLanguage)
            
            cell.label.text = "\(bedTimeStr) ~ \(wakeTimeStr)\n총 수면시간 \(durationStr)"
            cell.configureCell(type: cellType)
            
            return cell

        case .photo:
            let cell = tableView.dequeueReusableCell(withClass: PhotoTableViewCell.self, for: indexPath)
            
            guard let photos = log.photo else { return UITableViewCell() }
            
            let date = AppDateFormatter.shared.toString(date: log.date, type: .year)
            guard let photo = photos.first else { return UITableViewCell() }
            cell.photoView.image = PhotoManager.shared.loadImageFromDocument(date: date, fileName: photo.fileName)
            
            return cell

        case .diary:
            let cell = tableView.dequeueReusableCell(withClass: LabelTableViewCell.self, for: indexPath)
            
            guard let diary = log.diary else { return UITableViewCell() }
            
            cell.label.text = diary
            cell.configureCell(type: cellType)
            
            return cell
            
        default: return UITableViewCell()
        }
    }

}
