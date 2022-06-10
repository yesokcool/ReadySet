
import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    @Namespace private var dealingNamespace
    // TODO: Add some ways to speed up the game. Like if you match multiple sets quickly, you get a special vision that shows you sets to match and matching them has an intense POWERFUL-feeling animation, screen shake, pop up text saying quake-like stuff like unstoppable, particles of randomized emojis like cows etc. And if you keep matching fast, it keeps the mode going. Call this READY, SET, and have it flash on screen, kind of like Super Hot.
    // TODO: Add animation when breaking high score
    // TODO: Add shuffle button for fun?
    var body: some View {
        if !game.gameComplete() {
            VStack {
                if game.twoPlayers() {
                    multiplayerScoreAndControls(player1: false, color: .mint)
                        .rotationEffect(Angle.degrees(180))
                } else {
                    score
                    Divider().overlay(.blue)
                }
                
                if !game.twoPlayers() {
                    scoreModifier
                    Divider().overlay(.blue)
                }
                
                if game.cheatMode() {
                    showSolutions
                        .font(DrawingConstants.smallestFontSize)
                }
                
                cards
            
                Spacer()
                
                VStack {
                    if game.twoPlayers() {
                        multiplayerScoreAndControls(player1: true, color: .blue)
                    }
                    controls
                }
            }.foregroundColor(.primary)
        } else {
            gameComplete
        }
    }
    
    @State private var dealt = Set<Int>()
    @State private var faceUp = Set<Int>()
    
    private func deal(_ card: ShapeSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: ShapeSetGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func faceUp(_ card: ShapeSetGame.Card) {
        faceUp.insert(card.id)
    }
    
    private func isFaceUp(_ card: ShapeSetGame.Card) -> Bool {
        faceUp.contains(card.id)
    }
    
    private func dealAnimation(for card: ShapeSetGame.Card, index: Int) -> Animation {
        let delay = Double(index + 1) * (CardConstants.totalDealDuration / Double(game.getDeck().count))
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    /*private func flipAnimation(for card: ShapeSetGame.Card, index: Int) -> Animation {
        //let delay = Double(index * 1) * (CardConstants.totalDealDuration / Double(game.getDeck().count))
        let duration = CardConstants.dealDuration / Double(index + 1)
        return Animation.easeInOut(duration: duration) //.delay(5.0)
    }*/
    
    private func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(game.getDeck().firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.getDeck().filter( { isUndealt($0) } ).reversed()) { card in
                CardView(card: card, isFaceUp: isFaceUp(card) )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            // starting deal
            if game.getCardsInPlay().count == 0 {
                for i in 0..<12 {
                    withAnimation(dealAnimation(for: game.getDeck()[game.getDeck().count - 1], index: i)) {
                        game.deal()
                        deal(game.getCardsInPlay()[game.getCardsInPlay().count - 1])
                    }
                }
            // normal deal 3
            } else {
                for i in 0..<3 {
                    withAnimation(dealAnimation(for: game.getDeck()[game.getDeck().count - 1], index: i)) {
                        game.deal()
                        deal(game.getCardsInPlay()[game.getCardsInPlay().count - 1])
                    }
                }
            }
            for card in game.getCardsInPlay() {
                withAnimation(Animation.easeInOut(duration: CardConstants.dealDuration).delay(0.5)) {
                    faceUp(card)
                }
            }
            _ = game.checkIfSetIsAvailable()
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .padding(.horizontal)
    }
    
    // TODO: Make function for filling the buttons
    
    var controls: some View {
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
                game.colorblindToggle()
            } label: {
                game.colorblindMode ?
                    Image(systemName: "circle.hexagongrid.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .frame(width: DrawingConstants.controlButtonWidth)
                    : Image(systemName: "circle.hexagongrid.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
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
                game.cheatMode() ?
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(width: DrawingConstants.controlButtonWidth)
                : Image(systemName: "magnifyingglass.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
            Spacer()
            deckBody
        }
        .padding(.horizontal, 35.0)
        .padding(.vertical, 10.0)
        .foregroundColor(.blue)
    }
    
    var cards: some View {
        AspectVGrid(items: game.getCardsInPlay(), aspectRatio: 2/3) { card in
            if isUndealt(card) {
                Color.clear
            } else {
                CardView(card: card, colorblindMode: game.colorblindMode, isFaceUp: isFaceUp(card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            game.choose(card)
                        }
                }
            }
        }
        
    }
        
    var score: some View {
        HStack {
                VStack {
                    Text("HIGH SCORE")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.semibold)
                    Text("\(game.getHighScore()) \n\(game.anotherRandomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .fixedSize()
                }
                .foregroundColor(game.getHighScore() == game.getScore() &&
                                 game.getHighScore() != 0 ?
                                 Color.orange : Color.blue)
                .multilineTextAlignment(.center)
                
            Spacer()
            VStack {
                    Group {
                    Text("SCORE")
                            .font(DrawingConstants.scoreFontSize)
                            .fontWeight(.semibold)
                        Text("\(game.getScore()) \n\(game.randomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }
                .foregroundColor(game.getHighScore() == game.getScore() &&
                                 game.getHighScore() != 0 ?
                                 Color.orange : Color.blue)
                
            }
        }
        .padding(.horizontal, 40.0)
        .padding(.top, 5.0)
    }
    
    var scoreModifier: some View {
        Text("\(game.getScoreModifier()) \(game.randomScoreModifierText)")
            .font(DrawingConstants.scoreFontSize)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.all, 6.0)
            .multilineTextAlignment(.center)
    }
    
    var showSolutions: some View {
        if game.setAvailable() {
            return Text("\(game.cheatIndices().description)")

        }
        return Text("No sets!")
            .fontWeight(.semibold)
    }
    
    func multiplayerScoreAndControls(player1: Bool, color: Color) -> some View {
        VStack {
            Group {
                Text("SCORE: ")
                    .font(DrawingConstants.scoreFontSize)
                    .fontWeight(.heavy)
                Text(player1 ?
                     "\(game.getScore()) \(game.randomScoringText)"
                     : "\(game.getScore()) \(game.anotherRandomScoringText)" )
                    .font(DrawingConstants.scoreFontSize)
                    .fontWeight(.semibold)
                    .fixedSize()
            }
            .foregroundColor(game.getHighScore() == game.getScore() &&
                             game.getHighScore() != 0 ?
                             Color.orange : color)
            
            Button {
                if player1 {
                    game.turnToPlayerOne()
                } else {
                    game.turnToPlayerTwo()
                }
            } label: {
                if player1 {
                    !game.isPlayerOneTurn() ?
                    Image(systemName: "flag.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    : Image(systemName: "flag.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    game.isPlayerOneTurn() ?
                    Image(systemName: "flag.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    : Image(systemName: "flag.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                }
            }
            .foregroundColor(color)
            .frame(width: DrawingConstants.flagWidth)
        }
    }
    
    var gameComplete: some View {
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
        static let scoreFontSize = Font.caption
        static let smallestFontSize = Font.footnote
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2.0
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
     }

}

struct CardView: View {
    let card: ShapeSetGame.Card
    let colorblindMode: Bool
    let isFaceUp: Bool
    
    init(card: ShapeSetGame.Card, colorblindMode: Bool = false, isFaceUp: Bool) {
        self.card = card
        self.colorblindMode = colorblindMode
        self.isFaceUp = isFaceUp
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    renderTrait(with: geometry)
                }
            }
            .padding(8.0)
            .cardify(card: card, isFaceUp: isFaceUp)
        }
    }
    
    ///    Colorblind palette source:
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
        } else {
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
                    } else if card.traits[2].type == 1 {
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
                        } else {
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
                    } else if card.traits[2].type == 1 {
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
                    } else {
                        Squiggle()
                            .fill()
                            .foregroundColor(getColor(card.traits[3].type))
                    }
                default:
                    if card.traits[2].type == 2 {
                        Diamond(size: 5)
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(getColor(card.traits[3].type))
                    } else if card.traits[2].type == 1 {
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
                    } else {
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
