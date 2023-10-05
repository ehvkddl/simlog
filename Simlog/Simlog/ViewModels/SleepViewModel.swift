//
//  BedTimeViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

class SleepViewModel {
    
    var sleep: Observable<Sleep?> = Observable(nil)
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
    
    func getString(value: CGFloat) -> String {
        dateFormatter.dateFormat = "hh:mm a"
        
        let time = TimeInterval(value)
        let timeDate = Date(timeIntervalSinceReferenceDate: time)
        
        return dateFormatter.string(from: timeDate)
    }
    
    func getDurationString() -> String {
        dateFormatter.dateFormat = "HH:mm"
        
        guard let sleep = sleep.value else { return "총 수면시간" }
        
        let duration = sleep.wakeupTime - sleep.bedTime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        
        return "총 수면시간 \(dateFormatter.string(from: durationDate))"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 10.0) * 10
        value = adjustedMinutes * 60
    }
    
}
