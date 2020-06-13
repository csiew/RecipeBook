//
//  TimestampUtil.swift
//  Recipe Book
//
//  Created by Clarence Siew on 11/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

enum TimestampStyle: String, CaseIterable {
    case server
    case dateOnly
    case casualShort, casualLong
    
    var rawValue: String {
        switch self {
            case .server: return "yyyy-MM-dd'T'HH:mm:ss'Z'"
            case .dateOnly: return "d MMM yyyy"
            case .casualShort: return "EEEE, d MMM yyyy"
            case .casualLong: return "EEEE, d MMM yyyy, h:mm a"
        }
    }
}

class TimestampUtil {
    static func currentString() -> String {
        return TimestampUtil.dateToString(date: Date())
    }
    
    static func dateToString(date: Date, style: TimestampStyle = .server) -> String {
        let formatter = DateFormatter()
        // Get date for report data
        formatter.dateFormat = style.rawValue
        return formatter.string(from: date)
    }
}
