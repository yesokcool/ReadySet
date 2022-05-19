//
//  File.swift
//  Set
//
//

import Foundation
import SwiftUI

struct Theme {
    let themeName: String
    let numberOfPairsOfCardsToShow: Int
    let themeColor: String
    
    init(themeName: String themeColor: String) {
        self.themeName = themeName
        self.numberOfPairsOfCardsToShow = contentSet.count
        self.themeColor = themeColor
    }
}
