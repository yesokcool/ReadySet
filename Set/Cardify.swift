
import SwiftUI

struct Cardify: AnimatableModifier {
    let card: ShapeSetGame.Card
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation += newValue }
    }
    
    init(card: ShapeSetGame.Card) {
        rotation = card.isInPlay ? 0 : 180
        self.card = card
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if !card.isInPlay {
                ZStack {
                    shape
                        .fill()
                        .foregroundColor(.blue)
                    Image(systemName: "square.stack.3d.down.forward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 35.0, height: 35.0)
                }
            } else {
                shape
                    .fill()
                    .foregroundColor(.white)
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
                content
            }
        }.rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
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
