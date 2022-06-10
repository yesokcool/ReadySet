
import SwiftUI

struct Cardify: AnimatableModifier {
    let card: ShapeSetGame.Card
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation += newValue }
    }
    
    init(card: ShapeSetGame.Card, isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
        self.card = card
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                if card.isPartOfSet == true.intValue {
                    shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                        .foregroundColor(.green)
                } else if card.isPartOfSet == false.intValue {
                    shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                        .foregroundColor(.red)
                } else if card.isSelected {
                    shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                        .foregroundColor(.yellow)
                } else {
                    shape.stroke(lineWidth: DrawingConstants.lineWidth)
                }
            } else {
                shape.fill()
                shape.foregroundColor(.blue)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let selectionWidth: CGFloat = 6
    }
}

extension View {
    func cardify(card: ShapeSetGame.Card, isFaceUp: Bool) -> some View {
        self.modifier(Cardify(card: card, isFaceUp: isFaceUp))
    }
}
