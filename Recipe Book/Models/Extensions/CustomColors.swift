//
//  CustomColors.swift
//  Recipe Book
//
//  Created by Clarence Siew on 3/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Combine
import UIKit

extension UIColor {
    static var lightBeige: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.45, green: 0.4, blue: 0.35, alpha: 1.00)
                } else {
                    return UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.00)
                }
            }
        } else {
            return UIColor(red: 0.95, green: 0.9, blue: 0.85, alpha: 1.00)
        }
    }

    static var darkBeige: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.3, green: 0.4, blue: 0.45, alpha: 1.00)
                } else {
                    return UIColor(red: 0.85, green: 0.8, blue: 0.75, alpha: 1.00)
                }
            }
        } else {
            return UIColor(red: 0.85, green: 0.8, blue: 0.75, alpha: 1.00)
        }
    }
    
    
    static var lightBlue: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.45, green: 0.4, blue: 0.35, alpha: 1.00)
                } else {
                    return UIColor(red: 0.8, green: 0.9, blue: 0.95, alpha: 1.00)
                }
            }
        } else {
            return UIColor(red: 0.8, green: 0.9, blue: 0.95, alpha: 1.00)
        }
    }
}
