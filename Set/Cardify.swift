
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
                        .shadow(color: .green, radius: DrawingConstants.glowRadius)
                } else if card.isPartOfSet == false.intValue {
                    shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                        .foregroundColor(.red)
                        .shadow(color: .red, radius: DrawingConstants.glowRadius)
                } else if card.isSelected {
                    shape.stroke(lineWidth: DrawingConstants.selectionWidth)
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow, radius: DrawingConstants.glowRadius)
                } else {
                    shape.stroke(lineWidth: DrawingConstants.lineWidth)
                }
            } else {
                shape.fill()
                shape.foregroundColor(.blue)
            }
            content
                .rotationEffect(Angle.degrees(card.isPartOfSet != false.none ? 360 : 0))
                .animation(card.isPartOfSet != false.none ?
                           Animation.linear(duration: card.isPartOfSet == true.intValue ? 0.5 : 5.0).repeatForever(autoreverses: false)
                           : Animation.linear(duration: 0.5), value: card.isPartOfSet)
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let selectionWidth: CGFloat = 6
        static let glowRadius: CGFloat = 9
    }
}

extension View {
    func cardify(card: ShapeSetGame.Card, isFaceUp: Bool) -> some View {
        self.modifier(Cardify(card: card, isFaceUp: isFaceUp))
    }
}
