//
//  TimeDetection.swift
//  Recipe Book
//
//  Created by Clarence Siew on 9/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

enum TimeUnit: CaseIterable {
    case days, hours, minutes, seconds
}

final class TimeUnitSupplemental {
    static let unitDictionary: Dictionary<TimeUnit, String> = TimeUnitSupplemental.getAllUnits()
    
    static func getDescription(unit: TimeUnit) -> String {
        switch unit {
            case .days: return "days"
            case .hours: return "hours"
            case .minutes: return "minutes"
            case .seconds: return "seconds"
        }
    }
    
    static func getSearchPattern(unit: TimeUnit) -> String {
        switch unit {
            case .days: return #"(\d+)(\s+)(days|day)"#
            case .hours: return #"(\d+)(\s+)(hours|hour|hrs|hr)"#
            case .minutes: return #"(\d+)(\s+)(minutes|minute|mins|min)"#
            case .seconds: return #"(\d+)(\s+)(seconds|second|secs|sec)"#
        }
    }
    
    static func getAllUnits() -> Dictionary<TimeUnit, String> {
        var unitDictionary = Dictionary<TimeUnit, String>()
        TimeUnit.allCases.forEach {
            unitDictionary[$0] = TimeUnitSupplemental.getDescription(unit: $0)
        }
        return unitDictionary
    }
}

final class TimeDetection {
    static func detect(text: String) -> Int {
        var totalSeconds: Int = 0
        
        let daysPattern = TimeUnitSupplemental.getSearchPattern(unit: .days)
        let hoursPattern = TimeUnitSupplemental.getSearchPattern(unit: .hours)
        let minutesPattern = TimeUnitSupplemental.getSearchPattern(unit: .minutes)
        let secondsPattern = TimeUnitSupplemental.getSearchPattern(unit: .seconds)
        
        let days: [String] = TimeDetection.matches(for: daysPattern, in: text)
        let hours: [String] = TimeDetection.matches(for: hoursPattern, in: text)
        let minutes: [String] = TimeDetection.matches(for: minutesPattern, in: text)
        let seconds: [String] = TimeDetection.matches(for: secondsPattern, in: text)
        
        print(days)
        print(hours)
        print(minutes)
        print(seconds)
        
        for value in days {
            print(value.removeNonNumerical())
            totalSeconds += (Int(value.removeNonNumerical()) ?? 0) * 24 * 60 * 60
        }
        for value in hours {
            print(value.removeNonNumerical())
            totalSeconds += (Int(value.removeNonNumerical()) ?? 0) * 60 * 60
        }
        for value in minutes {
            print(value.removeNonNumerical())
            totalSeconds += (Int(value.removeNonNumerical()) ?? 0) * 60
        }
        for value in seconds {
            print(value.removeNonNumerical())
            totalSeconds += (Int(value.removeNonNumerical()) ?? 0)
        }
        
        return totalSeconds
    }
    
    static func batchDetect(textValues: [String]) -> Int {
        var totalSeconds = 0
        for text in textValues {
            totalSeconds += TimeDetection.detect(text: text)
        }
        return totalSeconds
    }
    
    // Based on solution by Martin R
    // https://stackoverflow.com/a/27880748
    static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map { String(text[Range($0.range, in: text)!]) }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    // Based on solution by GoZoner
    // https://stackoverflow.com/a/26794841
    static func secondsToDHMS (seconds : Int) -> (Int, Int, Int, Int) {
        return (seconds / 86400, (seconds % 86400) / 3600, (seconds % 86400) / 60, seconds % 60)
    }
}

extension String {
    public func removeNonNumerical() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789.").inverted)
    }
}
