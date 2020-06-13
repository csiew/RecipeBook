//
//  TimestampUtil.swift
//  Recipe Book
//
//  Created by Clarence Siew on 11/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

class TimestampUtil {
    static func currentString() -> String {
        return TimestampUtil.dateToString(date: Date())
    }
    
    static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        // Get date for report data
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter.string(from: date)
    }
}
