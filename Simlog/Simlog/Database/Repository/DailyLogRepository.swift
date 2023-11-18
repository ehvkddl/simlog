//
//  DailyLogRepository.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import Foundation
import RealmSwift

protocol DailyLogRepositoryProtocol {
    func fetch() -> Results<DailyLogTB>
    func addDailyLog(_ item: DailyLog)
}

final class DailyLogRepository: DailyLogRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func fetch() -> Results<DailyLogTB> {
        return realm.objects(DailyLogTB.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    func fetchDailyLog(on date: Date) -> Results<DailyLogTB> {
        return realm.objects(DailyLogTB.self).filter("date >= %@ AND date < %@", date, Date(timeInterval: 86400, since: date)).sorted(byKeyPath: "date", ascending: true)
    }
    
    func addDailyLog(_ item: DailyLog) {
        do {
            try realm.write {
                realm.add(convertToTB(item))
            }
        } catch {
            print("일기 저장 실패", error)
        }
    }
    
    func deleteDailyLog(_ item: DailyLog) {
        if let sleep = item.sleep {
            deleteSleep(sleep)
        }
        
        guard let record = realm.object(ofType: DailyLogTB.self, forPrimaryKey: item.id) else { return }
        do {
            try realm.write {
                realm.delete(record)
            }
        } catch {
            print("delete 실패", error)
        }
    }
    
    func deleteSleep(_ item: Sleep) {
//        let record = SleepTB(_id: item.id, bedTime: Float(item.bedTime), wakeupTime: Float(item.wakeupTime))
        guard let record = realm.object(ofType: SleepTB.self, forPrimaryKey: item.id) else { return }
        
        do {
            try realm.write {
                realm.delete(record)
            }
        } catch {
            print("delete 실패", error)
        }
    }
    
    private func convertToTB(_ log: DailyLog) -> DailyLogTB {
        var weathers = List<Int>()
        if let weahterLog = log.weather {
            weahterLog.forEach { weathers.append($0.rawValue) }
        }
        
        var sleep: SleepTB?
        if let sleepLog = log.sleep {
            sleep = SleepTB(bedTime: Float(sleepLog.bedTime), wakeupTime: Float(sleepLog.wakeupTime))
        }
        
        var photos = List<String>()
        if let photoLog = log.photo {
            photoLog.forEach { photos.append($0.fileName) }
        }
        
        return DailyLogTB(date: log.date, mood: log.mood ?? 0, weather: weathers, sleep: sleep, photo: photos, diary: log.diary)
    }
    
    func convertToMD(_ record: DailyLogTB) -> DailyLog {
        var weathers = [WeatherType]()
        if !record.weather.isEmpty {
            record.weather.forEach {
                guard let type = WeatherType(rawValue: $0) else {
                    print("database 변환 실패")
                    return
                }
                weathers.append(type)
            }
        }
        
        var sleep: Sleep?
        if let sleepRecord = record.sleep {
            sleep = Sleep(bedTime: CGFloat(sleepRecord.bedTime), wakeupTime: CGFloat(sleepRecord.wakeupTime))
        }
        
        var photos = [Photo]()
        if !record.photo.isEmpty {
            record.photo.forEach {
                photos.append(Photo(fileName: $0))
            }
        }
        
        return DailyLog(date: record.date, mood: record.mood, weather: weathers, sleep: sleep, photo: photos, diary: record.diary)
    }
    
}
