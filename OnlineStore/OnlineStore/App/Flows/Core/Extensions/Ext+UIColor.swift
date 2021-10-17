//
//  Ext+UIColor.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 22.09.2021.
//

import UIKit

extension UIColor {
    private static var colorsCache: [String: UIColor] = [:]
    
    public static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat) -> UIColor {
        let key = "\(red), \(green), \(blue), \(alpha)"
        
        if let cachedColor = self.colorsCache[key] {
            return cachedColor
        }
        
        self.clearColorsCacheIfNeeded()
        let color = UIColor(red: red,
                            green: green,
                            blue: blue,
                            alpha: alpha)
        self.colorsCache[key] = color
        return color
    }
    
    private static func clearColorsCacheIfNeeded() {
        guard self.colorsCache.count >= 100 else { return }
        colorsCache = [:]
    }
}

extension UIColor {
    
    static let gradientBegin = UIColor(red: 0.69,
                                       green: 0.95,
                                       blue: 0.95,
                                       alpha: 1.00)
    static let gradientEnd = UIColor(red: 1.0,
                                     green: 0.81,
                                     blue: 0.87,
                                     alpha: 1.00)
}
