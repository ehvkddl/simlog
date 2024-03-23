//
//  DateFormatterManager.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/16.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private lazy var formatters: [DateFormatType: DateFormatter] = [:]
    
    private init() {}
    
    func formatter(for type: DateFormatType,
                   locale: String = Locale.current.identifier,
                   timeZone: String = TimeZone.current.identifier
    ) -> DateFormatter {
        guard let formatter = formatters[type] else {
            let formatter = DateFormatter()
            formatter.dateFormat = type.description
            formatter.locale = Locale(identifier: locale)
            formatter.timeZone = TimeZone(abbreviation: timeZone)
            formatters[type] = formatter
            return formatter
        }
        
        return formatter
    }
}

extension DateFormatterManager {
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
}
