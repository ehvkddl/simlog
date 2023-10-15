//
//  DailyLogViewModel.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

class DailyLogViewModel {
    
    var dailylog: Observable<DailyLog> = Observable(DailyLog())
    let dailyLogRepository = DailyLogRepository()
    
    func saveDailyLog() {
        let log = dailylog.value
        
        guard log.mood != nil else {
            print("기분 점수는 필수 입력 요소입니다.")
            return
        }
        
        dailyLogRepository.addDailyLog(log)
        
        guard let photos = log.photo, let photo = photos.first else { return }
        PhotoManager.shared.saveImageToDocument(logID: log.id, fileName: "\(photo.id).jpg", image: photo.image)
    }
    
}
