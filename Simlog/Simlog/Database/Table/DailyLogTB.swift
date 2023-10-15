//
//  TDailyLog.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/11.
//

import Foundation
import RealmSwift

class DailyLogTB: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var date: Date
    @Persisted var mood: Int
    @Persisted var weather: List<Int>
    @Persisted var sleep: SleepTB?
    @Persisted var photo: List<String>
    @Persisted var diary: String?

    convenience init(
        _id: String,
        date: Date,
        mood: Int,
        weather: List<Int>,
        sleep: SleepTB? = nil,
        photo: List<String>,
        diary: String? = nil
    ) {
        self.init()
        
        self._id = _id
        self.date = date
        self.mood = mood
        self.weather = weather
        self.sleep = sleep
        self.photo = photo
        self.diary = diary
    }
}

class SleepTB: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var bedTime: Float
    @Persisted var wakeupTime: Float
    
    @Persisted(originProperty: "sleep") var dailyLog: LinkingObjects<DailyLogTB>
    
    convenience init(
        _id: String,
        bedTime: Float,
        wakeupTime: Float
    ) {
        self.init()
        
        self._id = _id
        self.bedTime = bedTime
        self.wakeupTime = wakeupTime
    }
}
