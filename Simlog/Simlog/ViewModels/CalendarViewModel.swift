//
//  CalendarViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/16.
//

import Foundation
import RealmSwift

class CalendarViewModel {
    
    var title: Observable<String> = Observable("")
    
    let dailyLogRepository = DailyLogRepository()
    var logs: Results<DailyLogTB>!
    
    func setCurrentPageTitle(date: Date) {
        title.value = AppDateFormatter.shared.toString(date: date, type: .calendarWithMonth)
    }
    
    func fetch() {
        self.logs = dailyLogRepository.fetch()
    }
    
    func fetchDailyLog(on date: Date) -> DailyLog? {
        let record = dailyLogRepository.fetchDailyLog(on: date)
        let dailyLog = record.isEmpty ? nil : dailyLogRepository.convertToMD(record.first!)
        
        return dailyLog
    }
    
}
