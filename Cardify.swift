//
//  Cardify.swift
//  Set
//

import SwiftUI

struct Cardify: ViewModifier {
    let card: ShapeSetGame.Card
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            shape
                .fill()
                .foregroundColor(.white)
            if (card.isPartOfSet == true.intValue) {
                shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                    .foregroundColor(.green)
            }
            else if (card.isPartOfSet == false.intValue) {
                shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                    .foregroundColor(.red)
            }
            else if (card.isSelected) {
                shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                    .foregroundColor(.yellow)
            }
            else {
                shape.stroke(lineWidth: DrawingConstants.lineWidth)
            }
            content
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let selectionWidth: CGFloat = 6
    }
}

extension View {
    func cardify(card: ShapeSetGame.Card) -> some View {
        self.modifier(Cardify(card: card))
    }
}
