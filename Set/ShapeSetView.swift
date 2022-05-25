
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
                            Image(systemName: "rectangle.stack.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)

                        }
                    }
                }
                .padding(.horizontal, 50.0)
                
            }.foregroundColor(.red)
    }
}

struct CardView: View {
    let card: ShapeSetGame.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .stroke(lineWidth: DrawingConstants.lineWidth)
                VStack {
                    ForEach(0..<card.traits[1].type + 1) { _ in
                        switch card.traits[0].type {
                        case 0:
                            if card.traits[2].type == 1 {
                                RoundedRectangle(cornerRadius:DrawingConstants.cornerRadius)
                                    .stroke(lineWidth: DrawingConstants.lineWidth)
                                    .foregroundColor(getColor(card.traits[3].type))
                            }
                            else {
                                RoundedRectangle(cornerRadius:DrawingConstants.cornerRadius)
                                    .fill()
                                    .foregroundColor(getColor(card.traits[3].type))
                                    .opacity(getOpacity(card.traits[2].type))
                            }
                        case 1:
                            if card.traits[2].type == 1 {
                                Circle()
                                    .stroke(lineWidth: DrawingConstants.lineWidth)
                                    .foregroundColor(getColor(card.traits[3].type))
                            }
                            else {
                                Circle()
                                    .fill()
                                    .foregroundColor(getColor(card.traits[3].type))
                                    .opacity(getOpacity(card.traits[2].type))
                            }
                                
                        default:
                            if card.traits[2].type == 1 {
                                Ellipse()
                                    .stroke(lineWidth: DrawingConstants.lineWidth)
                                    .foregroundColor(getColor(card.traits[3].type))
                            }
                            else {
                                Ellipse()
                                    .fill()
                                    .foregroundColor(getColor(card.traits[3].type))
                                    .opacity(getOpacity(card.traits[2].type))
                            }
                        }
                    }
                }
                .padding(5.0)
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
    
    func getOpacity(_ opacity: Int) -> Double {
        switch opacity {
            case 0:
                return 1.0
            case 1:
                return 0.5
            default:
                return 1.0
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
