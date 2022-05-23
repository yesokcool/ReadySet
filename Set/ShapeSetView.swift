
//
//  Created on 3/29/22.
//

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    
                }
                AspectVGrid(items: game.getCardsInPlay(), aspectRatio: 2/3) { card in
                    CardView(card: card).padding(4).onTapGesture {
                        game.choose(card)
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .fill()
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth:5)
                .foregroundColor(.gray)
        }
        .aspectRatio(2/3.5, contentMode: .fit)
        .padding(10)
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
