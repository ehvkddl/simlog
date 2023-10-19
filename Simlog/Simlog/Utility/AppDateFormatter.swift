//
//  AppDateFormatter.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/16.
//

import Foundation

enum DateFormatType {
    case year
    case calendarWithMonth
    case monthDayWeek
    case day
    case dayWithWeek
    case time
    case timeWithMeridiem
    case timeWithLanguage
    
    var description: String {
        switch self {
        case .year: return "yyyy-MM-dd"
        case .calendarWithMonth: return "yyyy년 M월"
        case .monthDayWeek: return "M월 d일 EEEE"
        case .day: return "d"
        case .dayWithWeek: return "d EE"
        case .time: return "HH:mm"
        case .timeWithMeridiem: return "hh:mm a"
        case .timeWithLanguage: return "h시간 m분"
        }
    }
}

class AppDateFormatter {
    
    static let shared = AppDateFormatter()
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
  
    func toString(date: Date,
                  locale: String = Locale.current.identifier,
                  timeZone: String = TimeZone.current.identifier,
                  type: DateFormatType) -> String
    {
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.dateFormat = type.description
        return dateFormatter.string(from: date)
    }
    
}
