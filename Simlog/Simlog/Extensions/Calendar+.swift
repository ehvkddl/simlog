//
//  Calendar+.swift
//  Simlog
//
//  Created by do hee kim on 2023/10/25.
//

import Foundation

extension Calendar {
    
    static func compareToday(to date: Date) -> ComparisonResult {
        return Calendar.current.compare(Date(), to: date, toGranularity: .day)
    }
    
}
