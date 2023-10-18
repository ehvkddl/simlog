//
//  DailyLog.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/05.
//

import Foundation

struct DailyLog: Hashable {
    var date: Date
    var mood: Int?
    var weather: [WeatherType]?
    var sleep: Sleep?
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
    
    var imageName: String {
        switch self {
        case .clear: return "sun"
        case .cloud: return "cloud"
        case .rain: return "rain"
        case .snow: return "snow"
        case .thunder: return "thunder"
        case .wind: return "wind"
        }
    }
}

struct Sleep: Hashable {
    var bedTime: CGFloat
    var wakeupTime: CGFloat
    var sleepTime: CGFloat {
         wakeupTime - bedTime
    }
}

struct Photo: Hashable {
    var image: Data?
    var fileName: String
}
