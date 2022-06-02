//
//  WideRoundedRectangle.swift
//  Set
//

import SwiftUI

struct WideRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return RoundedRectangle(cornerRadius: cornerRadius).path(in: rect)
    }
}
