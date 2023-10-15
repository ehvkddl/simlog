//
//  CalendarViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/16.
//

import Foundation

class CalendarViewModel {
    
    var title: Observable<String> = Observable("")
    
    func setCurrentPageTitle(date: Date) {
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
        
        title.value = AppDateFormatter.shared.toString(date: modifiedDate, type: .calendarWithMonth)
    }
    
}
