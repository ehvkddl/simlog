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
        
        return DateFormatterManager.shared.formatter(for: .timeWithMeridiem, timeZone: "UTC").string(from: timeDate)
    }
    
    func getDurationTimeString() -> String {
        guard let sleep = sleep.value else { return "총 수면시간" }
        
        let duration = sleep.wakeupTime - sleep.bedTime
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        
        let sleepStr = DateFormatterManager.shared.formatter(for: .time, timeZone: "UTC").string(from: durationDate)
        
        return "총 수면시간 \(sleepStr)"
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 10.0) * 10
        value = adjustedMinutes * 60
    }
    
}
