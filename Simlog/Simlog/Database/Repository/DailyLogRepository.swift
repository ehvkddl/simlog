//
//  DailyLogRepository.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import Foundation
import RealmSwift

final class DailyLogRepository: DailyLogRepositoryProtocol {
    
    private let realm = try! Realm()
    
    private lazy var dailyLog: Results<DailyLogTB>! = self.fetch()

    func fetch() -> Results<DailyLogTB> {
        return realm.objects(DailyLogTB.self).sorted(byKeyPath: "_id", ascending: false)
    }
    
    func addDailyLog(_ item: DailyLog) {
        do {
            try realm.write {
                realm.add(convertToTB(item))
            }
        } catch {
            print("일기 저장 실패", error)
        }
        print(dailyLog!)
    }
    
    private func convertToTB(_ log: DailyLog) -> DailyLogTB {
        var weathers = List<Int>()
        if let weahterLog = log.weather {
            weahterLog.forEach { weathers.append($0.rawValue) }
        }
        
        var sleep: SleepTB?
        if let sleepLog = log.sleep {
            sleep = SleepTB(_id: sleepLog.id, bedTime: Float(sleepLog.bedTime), wakeupTime: Float(sleepLog.wakeupTime))
        }
        
        return DailyLogTB(_id: log.id, date: Date(), mood: log.mood ?? 0, weather: weathers, sleep: sleep, diary: log.diary)
    }
    
}
