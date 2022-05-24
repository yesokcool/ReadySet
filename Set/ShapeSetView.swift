
//
//  Created on 3/29/22.
//

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    var body: some View {
            VStack {
                VStack {
                    Text("Set")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                AspectVGrid(items: game.getDeck(), aspectRatio: 2/3) { card in
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                        game.choose(card)
                    }
                }
            }.foregroundColor(.red)
    }
}

struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: DrawingConstants.lineWidth)
                ForEach(0..<card.traits[2].type) { _ in
                    switch card.traits[0].type {
                    case 0:
                        let rect = RoundedRectangle(cornerRadius: 10)
                        rect.fill().foregroundColor(getColor(card.traits[3].type)).padding(5.0)
                    case 1:
                        let circle = Circle()
                        circle.fill().foregroundColor(getColor(card.traits[3].type)).padding(5.0)
                    case 2:
                        let ellipse = Ellipse()
                        ellipse.fill().foregroundColor(getColor(card.traits[3].type)).padding(5.0)
                    default:
                        let circle = Circle()
                        circle.fill().foregroundColor(getColor(card.traits[3].type)).padding(5.0)
                    }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(4, 3, 3)
        return ShapeSetView(game: game).preferredColorScheme(.dark)
    }
}
