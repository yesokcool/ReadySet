
//
//  Created on 3/29/22.
//

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    var body: some View {
            VStack {
                AspectVGrid(items: game.getDeck(), aspectRatio: 2/3) { card in
                    CardView(card: card).padding(4).onTapGesture {
                        game.choose(card)
                    }
                }
            }
    }
}

struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        ZStack {
            ForEach(0..<card.traits[2].type) { _ in
                switch card.traits[0].type {
                case 0:
                    let shape = RoundedRectangle(cornerRadius: 10)
                    shape.fill().foregroundColor(getColor(card.traits[3].type))
                case 1:
                    let shape = Circle()
                    shape.fill().foregroundColor(getColor(card.traits[3].type))
                case 2:
                    let shape = Ellipse()
                    shape.fill().foregroundColor(getColor(card.traits[3].type))
                default:
                    let shape = Circle()
                    shape.fill().foregroundColor(getColor(card.traits[3].type))
                }
            }
        }
    }
    
    func getColor(_ color: Int) -> Color {
        switch color {
            case 0:
                return .blue
            case 1:
                return .red
            default:
                return .green
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let frontScale: CGFloat = 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(4, 3, 3)
        return ShapeSetView(game: game).preferredColorScheme(.dark)
    }
}
