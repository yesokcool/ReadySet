
import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    // TODO: Add animation when breaking high score
    var body: some View {
        if (!game.gameComplete()) {
            VStack {
                VStack {
                    Text("IT'S ALL UP TO YOU.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("YOU'VE EARNED \(game.getHighScore()) IMAGINARY GOOD JOB POINTS. WOW.")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(game.getHighScore() == game.getScore() ? Color.red : Color.yellow)
                        .multilineTextAlignment(.center)
                    Text("\(game.getScore()) OCEANS SAVED.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(game.getHighScore() == game.getScore() ? Color.red : Color.primary)
                    Text("\(game.getScoreModifier()) PUPPIES ARE DEPENDING ON YOU.")
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
                    renderTrait(with: geometry)
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
    
    // TODO: There may be a way to generalize these shapes more so it's easier to add in more shapes. e.g putting the shapes in an array, iterating through the array instead of literally writing shapes. Would have to make sure to add some sort of parameter for their frame maxheight though. then use ternary to check for it
    @ViewBuilder func renderTrait(with geometry: GeometryProxy) -> some View {
        let cornerRadiusRectangle: CGFloat = geometry.size.width * 0.3
        let rectangleHeight: CGFloat = geometry.size.height * 0.2
        let lineWidth: CGFloat = geometry.size.width * 0.03
        
        ForEach(0..<card.traits[0].type + 1, id: \.self) { _ in
            switch card.traits[1].type {
            case 0:
                if card.traits[2].type == 2 {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                }
                else if card.traits[2].type == 1 {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                        .background() {
                            WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
                                .frame(maxHeight: rectangleHeight)
                        }
                    }
                else {
                    WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                        .fill()
                        .foregroundColor(getColor(card.traits[3].type))
                        .frame(maxHeight: rectangleHeight)
                }
            case 1:
                if card.traits[2].type == 2 {
                    Squiggle()
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Squiggle()
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Squiggle()
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
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
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                }
                else if card.traits[2].type == 1 {
                    Diamond(size:5)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(getColor(card.traits[3].type))
                        .background() {
                            Diamond(size:5)
                                .fill()
                                .foregroundColor(getColor(card.traits[3].type))
                                //.opacity(getOpacity(card.traits[2].type))
                                .striped(geometry: geometry)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(4, 3, 3)
        return ShapeSetView(game: game).preferredColorScheme(.dark)
    }
}
