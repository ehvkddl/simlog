//
//  BedTimeViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

class SleepViewModel {
    
    var sleep: Observable<Sleep?> = Observable(nil)
    
    func getTimeWithMeridiemString(value: CGFloat) -> String {
        let time = TimeInterval(value)
        let timeDate = Date(timeIntervalSinceReferenceDate: time)
        
        return AppDateFormatter.shared.toString(date: timeDate, timeZone: "UTC", type: .timeWithMeridiem)
    }
    
    func getDurationTimeString() -> String {
        guard let sleep = sleep.value else { return "총 수면시간" }
        
        let duration = sleep.wakeupTime - sleep.bedTime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        
        return "총 수면시간 \(AppDateFormatter.shared.toString(date: durationDate, timeZone: "UTC", type: .time))"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 10.0) * 10
        value = adjustedMinutes * 60
    }
    
}
