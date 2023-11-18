//
//  DailyLogViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

class DailyLogViewModel {
    
    var dailylog: Observable<DailyLog> = Observable(DailyLog(date: Date()))
    let dailyLogRepository = DailyLogRepository()
    
    func saveDailyLog() {
        let log = dailylog.value
        
        guard log.mood != nil else {
            print("기분 점수는 필수 입력 요소입니다.")
            return
        }
        
        if dailyLogRepository.fetchDailyLog(with: log.id) {
            dailyLogRepository.updateDailyLog(log)
        } else {
            dailyLogRepository.addDailyLog(log)
        }
        
        guard let photos = log.photo, let photo = photos.first, let image = photo.image else { return }
        let date = AppDateFormatter.shared.toString(date: log.date, type: .year)
        PhotoManager.shared.saveImageToDocument(date: date, fileName: photo.fileName, image: image)
    }
    
}
