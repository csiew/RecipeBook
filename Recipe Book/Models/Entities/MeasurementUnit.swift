//
//  MeasurementUnit.swift
//  Recipe Book
//
//  Created by Clarence Siew on 10/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation

enum MeasurementUnit: String, CaseIterable {
    case none
    case mililitre, litre
    case miligram, gram, kilogram
    case teaspoon, tablespoon, ladle
    case cup, mug, bowl, sauceplatter, casseroledish, bakingtray
    case piece, stick, block, pinch, quarts
    
    var rawValue: String {
        switch self {
            case .none: return "none"
            case .mililitre: return "mililitre"
            case .litre: return "litre"
            case .miligram: return "miligram"
            case .gram: return "gram"
            case .kilogram: return "kilogram"
            case .teaspoon: return "teaspoon"
            case .tablespoon: return "tablespoon"
            case .ladle: return "ladle"
            case .cup: return "cup"
            case .mug: return "mug"
            case .bowl: return "bowl"
            case .sauceplatter: return "sauceplatter"
            case .casseroledish: return "casseroledish"
            case .bakingtray: return "bakingtray"
            case .piece: return "piece"
            case .stick: return "stick"
            case .block: return "block"
            case .pinch: return "pinch"
            case .quarts: return "quarts"
        }
    }
}

final class MeasurementUnitSupplemental {
    static let unitDictionary: Dictionary<MeasurementUnit, String> = MeasurementUnitSupplemental.getAllUnits()
    
    static func getShortDescription(unit: MeasurementUnit) -> String {
        switch unit {
        case .none: return ""
        case .mililitre: return "ml"
        case .litre: return "l"
        case .miligram: return "mg"
        case .gram: return "g"
        case .kilogram: return "kg"
        case .teaspoon: return "tsp"
        case .tablespoon: return "tbsp"
        case .ladle: return "ladle"
        case .cup: return "cup"
        case .mug: return "mug"
        case .bowl: return "bowl"
        case .sauceplatter: return "sauceplatter"
        case .casseroledish: return "dish"
        case .bakingtray: return "tray"
        case .piece: return "piece"
        case .stick: return "stick"
        case .block: return "block"
        case .pinch: return "pinch"
        case .quarts: return "quarts"
        }
    }
    
    static func getLongDescription(unit: MeasurementUnit) -> String {
        switch unit {
        case .none: return "None"
        case .mililitre: return "Mililitre"
        case .litre: return "Litre"
        case .miligram: return "Miligram"
        case .gram: return "Gram"
        case .kilogram: return "Kilogram"
        case .teaspoon: return "Teaspoon"
        case .tablespoon: return "Tablespoon"
        case .ladle: return "Ladle"
        case .cup: return "Cup"
        case .mug: return "Mug"
        case .bowl: return "Bowl"
        case .sauceplatter: return "Sauceplatter"
        case .casseroledish: return "Casserole Dish"
        case .bakingtray: return "Baking Tray"
        case .piece: return "Piece"
        case .stick: return "Stick"
        case .block: return "Block"
        case .pinch: return "Pinch"
        case .quarts: return "Quarts"
        }
    }
    
    static func getAllUnits() -> Dictionary<MeasurementUnit, String> {
        var unitDictionary = Dictionary<MeasurementUnit, String>()
        MeasurementUnit.allCases.forEach {
            unitDictionary[$0] = MeasurementUnitSupplemental.getLongDescription(unit: $0)
        }
        return unitDictionary
    }
}
