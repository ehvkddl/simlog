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
    case time
    case timeWithMeridiem
    
    var description: String {
        switch self {
        case .year: return "yyyy-MM-dd"
        case .calendarWithMonth: return "yyyy년 M월"
        case .time: return "HH:mm"
        case .timeWithMeridiem: return "hh:mm a"
        }
    }
}

class AppDateFormatter {
    
    static let shared = AppDateFormatter()
    private init() {}
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }()
  
    func toString(date: Date, type: DateFormatType) -> String {
        dateFormatter.dateFormat = type.description
        return dateFormatter.string(from: date)
    }
    
}
