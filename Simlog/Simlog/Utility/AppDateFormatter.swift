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
        case .timeWithLanguage: return "HH시간 mm분"
        }
    }
}

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private lazy var formatters: [DateFormatType: DateFormatter] = [:]
    
    private init() {}
    
    func formatter(for type: DateFormatType) -> DateFormatter {
        if let formatter = formatters[type] {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = type.description
            formatter.locale = Locale(identifier: "ko_KR") // 로케일 설정
            formatters[type] = formatter
            return formatter
        }
    }
}

class AppDateFormatter {
    
    static let shared = AppDateFormatter()
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = DateFormatter()
  
    func toString(date: Date,
                  locale: String = Locale.current.identifier,
                  timeZone: String = TimeZone.current.identifier,
                  type: DateFormatType) -> String
    {
        var result: String = ""
        let queue = DispatchQueue(label: "DateFormatterQueue")
        
        queue.sync {
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
            dateFormatter.locale = Locale(identifier: locale)
            dateFormatter.dateFormat = type.description
            result = dateFormatter.string(from: date)
        }
        
        return result
    }
    
    func toDate(date: String,
                locale: String = Locale.current.identifier,
                timeZone: String = TimeZone.current.identifier,
                type: DateFormatType) -> Date?
    {
        var result: Date = Date()
        let queue = DispatchQueue(label: "DateFormatterQueue")
        
        queue.sync {
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
            dateFormatter.locale = Locale(identifier: locale)
            dateFormatter.dateFormat = type.description
            result = dateFormatter.date(from: date) ?? Date()
        }
        
        return result
    }
    
}
