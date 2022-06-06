
import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    
    // TODO: Make text pull from a library of possible texts randomly for each game
    // TODO: Add some ways to speed up the game. Like if you match multiple sets quickly, you get a special vision that shows you sets to match and matching them has an intense POWERFUL-feeling animation, screen shake, pop up text saying quake-like stuff like unstoppable, particles of randomized emojis like cows etc. And if you keep matching fast, it keeps the mode going.
    // TODO: Add animation when breaking high score
    var body: some View {
        if (!game.gameComplete()) {
            VStack {
                VStack {
                    if game.twoPlayers() {
                        playerTwoControls()
                    }
                }
                score()
                if !game.twoPlayers() {
                    scoreModifier()
                }
                if game.cheatMode {
                    showSolutions()
                }
                cards()
                
                Spacer()
                VStack {
                    if game.twoPlayers() {
                        playerOneControls()
                    }
                    controls()
                }
                
                
            }.foregroundColor(.primary)
        }
        else {
            gameComplete()
        }
    }
    
    @ViewBuilder func buttonBuilder() -> some View {
        if (game.deckEmpty()) {
            Image(systemName: "square.stack.3d.down.right.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DrawingConstants.controlButtonWidth)
                .opacity(0)
        }
        else {
            Image(systemName: "square.stack.3d.down.right.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DrawingConstants.controlButtonWidth)
        }
    }
    
    func controls() -> some View {
        HStack() {
            Button {
                game.newGame()
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
            Spacer()
            Button {
                game.twoPlayerMode()
            } label: {
                game.twoPlayers() ?
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: DrawingConstants.controlButtonWidth)
                    : Image(systemName: "person.2.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: DrawingConstants.controlButtonWidth)
            }
            Spacer()
            Button {
                game.cheatToggle()
            } label: {
                game.cheatMode ?
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(width: DrawingConstants.controlButtonWidth)
                :
                Image(systemName: "magnifyingglass.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
            Spacer()
            Button {
                game.dealThree()
            } label: {
                buttonBuilder()
            }
        }
        .padding(.horizontal, 35.0)
        .padding(.vertical, 10.0)
        .foregroundColor(.blue)
    }
    
    func cards() -> some View {
        AspectVGrid(items: game.getCardsInPlay(), aspectRatio: 2/3) { card in
            CardView(card: card, colorblindMode: game.colorblindMode)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
            }
        }
    }
        
    func score() -> some View {
        HStack {
            if !game.twoPlayers() {
                VStack {
                    Text("HIGH SCORE:")
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text("\(game.getHighScore()) GOOD JOBS")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .foregroundColor(game.getHighScore() == game.getScore() &&
                                 game.getHighScore() != 0 ?
                                 Color.orange : Color.blue)
                .multilineTextAlignment(.center)
            }
            VStack {
                if !game.twoPlayers() {
                    Group {
                    Text("SCORE: ")
                            .font(.title3)
                            .fontWeight(.heavy)
                    Text("\(game.getScore()) OCEANS SAVED")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .foregroundColor(game.getHighScore() == game.getScore() &&
                                 game.getHighScore() != 0 ?
                                 Color.orange : Color.blue)
                }
            }
        }
        .padding(.horizontal, 25.0)
        .padding(.top, 5.0)
    }
    
    func scoreModifier() -> some View {
        Text("\(game.getScoreModifier()) PUPPIES ARE DEPENDING ON YOU")
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.all, 6.0)
    }
    
    func showSolutions() -> some View {
        if game.setAvailable() {
            return Text("\(game.cheatIndices().description)")
                .font(.title3)
                .fontWeight(.semibold)
        }
        return Text("No sets!")
            .font(.title3)
            .fontWeight(.semibold)
    }
    
    func playerOneControls() -> some View {
        VStack {
            Group {
            Text("SCORE: ")
                    .font(.title3)
                    .fontWeight(.heavy)
            Text("\(game.getScore()) OCEANS SAVED")
                .font(.body)
                .fontWeight(.semibold)
        }
        .foregroundColor(game.getHighScore() == game.getScore() &&
                         game.getHighScore() != 0 ?
                         Color.orange : Color.blue)
            Button {
                game.playerOneTurn()
            } label: {
                Image(systemName: "flag.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: DrawingConstants.flagWidth)
            }
        }
    }
    
    func playerTwoControls() -> some View {
        HStack {
            VStack {
                Group {
                    Button {
                        game.playerTwoTurn()
                    } label: {
                        Image(systemName: "flag.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.mint)
                    }
                    .frame(width: DrawingConstants.flagWidth)
                    Text("\(game.getScorePlayerTwo()) OCEANS SAVED")
                        .font(.body)
                        .fontWeight(.semibold)
                    Text("P2 SCORE: ")
                            .font(.title3)
                            .fontWeight(.heavy)
                }
                .rotationEffect(Angle.degrees(180))
                .foregroundColor(game.getHighScore() == game.getScorePlayerTwo() &&
                                 game.getHighScore() != 0 ?
                                 Color.orange : Color.mint)
            }
        }
    }
    
    func gameComplete() -> some View {
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
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DrawingConstants.controlButtonWidth)
                }
            }
        }
    }
    
    struct DrawingConstants {
        static let flagWidth: CGFloat = 80.0
        static let controlButtonWidth: CGFloat = 35.0
        static let controlSpacing: CGFloat = 10.0
    }
}

struct CardView: View {
    let card: ShapeSetGame.Card
    let colorblindMode: Bool
    
    init(card: ShapeSetGame.Card, colorblindMode: Bool = false) {
        self.card = card
        self.colorblindMode = colorblindMode
    }
    
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
    
    ///    Colorblind palette sourced from the article:
    ///    **What to consider when visualizing data for colorblind readers**
    ///    *by Lisa Charlotte Muth*
    
    func getColor(_ color: Int) -> Color {
        if !colorblindMode {
            switch color {
                case 0:
                    return .cyan
                case 1:
                    return .pink
                default:
                    return .green
            }
        }
        else {
            switch color {
                case 0:
                return Color.init(hue: 0.58, saturation: 1.0, brightness: 0.88)
                case 1:
                return Color.init(hue: 0.54, saturation: 0.3, brightness: 0.99)
                default:
                    return .orange
            }
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
        return ShapeSetView(game: game).preferredColorScheme(.light)
    }
}
