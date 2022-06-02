
//
//  Created on 3/29/22.
//

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    var body: some View {
        if (!game.gameComplete()) {
            VStack {
                VStack {
                    Text("Set")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("SCORE: \(game.getScore())")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                AspectVGrid(items: game.getCardsInPlay(), aspectRatio: 2/3) { card in
                    CardView(card: card)
                        .padding(4)
                        .onTapGesture {
                            game.choose(card)
                    }
                }
                
                HStack() {
                    Button {
                        game.newGame()
                    } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                    }
                    Spacer()
                    Button {
                            game.dealThree()
                    } label: {
                        VStack(alignment: .center) {
                            buttonBuilder()
                        }
                    }
                }
                .padding(.horizontal, 50.0)
                .padding(.bottom, 10.0)
                
            }.foregroundColor(.primary)
        }
        else {
            VStack {
                Text("GAME COMPLETE!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("FINAL SCORE: \(game.getScore())")
                    .font(.title2)
                    .fontWeight(.semibold)
                Button {
                    game.newGame()
                } label: {
                    VStack {
                    Text("NEW GAME?")
                        .font(.title)
                        .padding(10)
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func buttonBuilder() -> some View {
        if (game.deckEmpty()) {
            Image(systemName: "rectangle.stack.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .opacity(0)
        }
        else {
            Image(systemName: "rectangle.stack.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
        }
    }
}

// TODO: Can probably make a @Viewbuilder function that returns Some View instead
// of these long switch statements?
struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    renderTrait()
                }
            }
            .padding(8.0)
            .cardify(card: card)
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
    
    func getOpacity(_ opacity: Int) -> Double {
        switch opacity {
            case 1:
                return 0.3
            default:
                return 1.0
        }
    }
    
    @ViewBuilder func renderTrait() -> some View {
        ForEach(0..<card.traits[0].type + 1, id: \.self) { _ in
            switch card.traits[1].type {
            case 0:
                if card.traits[2].type == 2 {
                    RoundedRectangle(cornerRadius:DrawingConstants.cornerRadiusRectangle)
                        .stroke(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                        RoundedRectangle(cornerRadius:DrawingConstants.cornerRadiusRectangle)
                            .stroke(lineWidth: DrawingConstants.lineWidth)
                            .foregroundColor(getColor(card.traits[3].type))
                            .background() {
                                RoundedRectangle(cornerRadius:DrawingConstants.cornerRadiusRectangle)
                                    .fill()
                                    .foregroundColor(getColor(card.traits[3].type))
                                    .opacity(getOpacity(card.traits[2].type))
                            }
                    }
                else {
                    RoundedRectangle(cornerRadius:DrawingConstants.cornerRadiusRectangle)
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                }
            case 1:
                if card.traits[2].type == 2 {
                    Squiggle()
                        .stroke(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Squiggle()
                        .stroke(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Squiggle()
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                .opacity(getOpacity(card.traits[2].type))
                        }
                }
                else {
                    Squiggle()
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                }
            default:
                if card.traits[2].type == 2 {
                    Diamond(size: 5)
                        .stroke(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Diamond(size:5)
                        .stroke(lineWidth: DrawingConstants.lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Diamond(size:5)
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                .opacity(getOpacity(card.traits[2].type))
                        }
                }
                else {
                    Diamond(size:5)
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                }
            }
        }
    }
    
    private struct DrawingConstants {
        static let lineWidth: CGFloat = 3
        static let cornerRadiusRectangle: CGFloat = 64.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(4, 3, 3)
        return ShapeSetView(game: game).preferredColorScheme(.dark)
    }
}
