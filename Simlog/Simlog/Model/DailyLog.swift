//
//  DailyLog.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

struct DailyLog: Hashable {
    let id = UUID().uuidString
    var date: Date
    var mood: Int?
    var weather: [WeatherType]?
    var meal: [Meal]?
    var sleep: Sleep?
    var todo: [Todo]?
    var photo: [Photo]?
    var diary: String?
}

enum WeatherType: Int {
    case clear
    case cloud
    case rain
    case snow
    case thunder
    case wind
}

struct Meal: Hashable {
    let id = UUID().uuidString
    var time: MealType
    var photo: String?
}

enum MealType: Int {
    case breakfast
    case lunch
    case dinner
    case snack
}

struct Sleep: Hashable {
    let id = UUID().uuidString
    var bedTime: CGFloat
    var wakeupTime: CGFloat
    var sleepTime: CGFloat {
         wakeupTime - bedTime
    }
}

struct Todo: Hashable {
    let id = UUID().uuidString
    var title: String
    var state: TodoState
}

enum TodoState: Int {
    case notStarted
    case inProgress
    case complete
}

struct Photo: Hashable {
    let id = UUID().uuidString
    var image: Data
}
