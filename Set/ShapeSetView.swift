
// TODO: Add some ways to speed up the game. Like if you match multiple sets quickly, you get a special vision that shows you sets to match and matching them has an intense POWERFUL-feeling animation, screen shake, pop up text saying quake-like stuff like unstoppable, particles of randomized emojis like cows etc. And if you keep matching fast, it keeps the mode going. Call this READY, SET, and have it flash on screen, kind of like Super Hot.
// TODO: Add animation when breaking high score
// TODO: Add shuffle button for fun?

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        if !game.complete() {
            VStack {
                if game.isMultiplayer() {
                    multiplayerScoreAndControls(forPlayerOne: false, havingTeamColor: .mint)
                        .rotationEffect(Angle.degrees(180))
                } else {
                    scoreboard
                    Divider().overlay(.blue)
                }
                
                if !game.isMultiplayer() {
                    scoreModifier
                    Divider().overlay(.blue)
                }
                
                if game.hasCheatVision() {
                    showSolutions
                        .font(DrawingConstants.smallestFontSize)
                }
                
                dealtOutCards
            
                Spacer()
                
                VStack {
                    if game.isMultiplayer() {
                        multiplayerScoreAndControls(forPlayerOne: true, havingTeamColor: .blue)
                    }
                    bottomControls
                }
            }.foregroundColor(.primary)
        } else {
            completedGame
        }
    }
    
    @State private var dealt = Set<Int>()
    @State private var faceUp = Set<Int>()
    
    private func deal(_ card: ShapeSetGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isNotDealt(_ card: ShapeSetGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func turnFaceUp(_ card: ShapeSetGame.Card) {
        faceUp.insert(card.id)
    }
    
    private func isFaceUp(_ card: ShapeSetGame.Card) -> Bool {
        faceUp.contains(card.id)
    }
    
    private func dealAnimation(for card: ShapeSetGame.Card, index: Int) -> Animation {
        let delay = Double(index + 1) * (CardConstants.totalDealDuration / Double(game.deck().count))
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    var dealtOutCards: some View {
        AspectVGrid(items: game.cardsInPlay(), aspectRatio: 2/3) { card in
            if isNotDealt(card) {
                Color.clear
            } else {
                CardView(card: card, colorblindMode: game.isUsingColorblindAssistance, isFaceUp: isFaceUp(card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .animation(Animation.spring(), value: card.isPartOfSet)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            game.choose(card)
                        }
                }
            }
        }
        
    }
    
    var deckOfCards: some View {
        ZStack {
            ForEach(game.deck().filter( { isNotDealt($0) } ).reversed()) { card in
                CardView(card: card, isFaceUp: isFaceUp(card) )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            // starting deal
            if game.cardsInPlay().count == 0 {
                for i in 0..<12 {
                    withAnimation(dealAnimation(for: game.deck()[game.deck().count - 1], index: i)) {
                        game.deal()
                        deal(game.cardsInPlay()[game.cardsInPlay().count - 1])
                    }
                } // normal deal 3
            } else {
                for i in 0..<3 {
                    withAnimation(dealAnimation(for: game.deck()[game.deck().count - 1], index: i)) {
                        game.deal()
                        deal(game.cardsInPlay()[game.cardsInPlay().count - 1])
                    }
                }
            }
            for card in game.cardsInPlay() {
                withAnimation(Animation.easeInOut(duration: CardConstants.dealDuration).delay(0.5)) {
                    turnFaceUp(card)
                }
            }
            game.lookForSet()
        }
        .frame(width: CardConstants.notDealtWidth, height: CardConstants.notDealtHeight)
        .padding(.horizontal)
    }
    
    var discardedCardPile: some View {
        ZStack {
            ForEach(game.setsMade(), id: \.self) { aSet in
                ForEach(aSet) { card in
                    CardView(card: card, isFaceUp: isFaceUp(card) )
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                        .offset(x: cardOffset(forCardAtIndex: aSet.firstIndex(of: card)!, along: Axis.horizontal), y: cardOffset(forCardAtIndex: aSet.firstIndex(of: card)!, along: Axis.vertical))
                }
            }
        }
        .frame(width: CardConstants.notDealtWidth, height: CardConstants.notDealtHeight)
        .padding(.horizontal)
    }

    private func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(game.deck().firstIndex(where: { $0.id == card.id}) ?? 0)
    }
    
    func cardOffset(forCardAtIndex index: Int, along axis: Axis) -> CGFloat {
        switch axis {
        case Axis.horizontal:
            switch index {
                case 1:
                    return 0.0
                case 2:
                    return CardConstants.stackXOffset
                default:
                    return -CardConstants.stackXOffset
            }
        default:
            switch index {
            case 0:
                return CardConstants.stackYOffset * 2
            case 1:
                return -CardConstants.stackYOffset
            default:
                return CardConstants.stackYOffset * 4
            }
        }
    }
    
    // TODO: Make function for filling the buttons
    
    var bottomControls: some View {
        HStack() {
            discardedCardPile
            Spacer()
            Button {
                game.startNewGame()
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
            Spacer()
            pushButton(withImage: Image(systemName: "circle.hexagongrid.circle.fill"),
                              whenPressedIs: Image(systemName: "circle.hexagongrid.circle"),
                              whichDoes: game.toggleColorblindAssistance,
                              checksWith: game.isUsingColorblindAssistance,
                              color1: .blue)
            Spacer()
            pushButton(withImage: Image(systemName: "person.2.circle.fill"),
                              whenPressedIs: Image(systemName: "person.2.circle"),
                              whichDoes: game.toggleMultiplayer,
                              checksWith: game.isMultiplayer(),
                              color1: .blue)
            Spacer()
            pushButton(withImage: Image(systemName: "magnifyingglass.circle.fill"),
                              whenPressedIs: Image(systemName: "magnifyingglass.circle"),
                              whichDoes: game.toggleCheatVision,
                              checksWith: game.hasCheatVision(),
                              color1: .red, color2: .blue)
            deckOfCards
        }
        .padding(.horizontal, 35.0)
        .padding(.vertical, 10.0)
        .foregroundColor(.blue)
    }
    
    func pushButton(withImage buttonImage: Image, whenPressedIs buttonImageWhenPressed: Image,
                           whichDoes function: @escaping () -> Void, checksWith conditional: Bool? = nil,
                           color1: Color, color2: Color? = nil) -> some View {
        return Button {
            function()
        } label: {
            if let conditional = conditional {
                conditional ?
                buttonImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color1)
                    .frame(width: DrawingConstants.controlButtonWidth)
                :
                buttonImageWhenPressed
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color2 ?? color1)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
        }
    }
        
    var scoreboard: some View {
        HStack {
                VStack {
                    Text("HIGH SCORE")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.semibold)
                    Text("\(game.highScore()) \n\(game.anotherRandomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .fixedSize()
                }
                .foregroundColor(game.highScore() == game.score() &&
                                 game.highScore() != 0 ?
                                 Color.orange : Color.blue)
                .multilineTextAlignment(.center)
                
            Spacer()
            VStack {
                    Group {
                    Text("SCORE")
                            .font(DrawingConstants.scoreFontSize)
                            .fontWeight(.semibold)
                        Text("\(game.score()) \n\(game.randomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }
                .foregroundColor(game.highScore() == game.score() &&
                                 game.highScore() != 0 ?
                                 Color.orange : Color.blue)
                
            }
        }
        .padding(.horizontal, 40.0)
        .padding(.top, 5.0)
    }
    
    var scoreModifier: some View {
        Text("\(game.scoreModifier()) \(game.randomScoreModifierText)")
            .font(DrawingConstants.scoreFontSize)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.all, 6.0)
            .multilineTextAlignment(.center)
    }
    
    var showSolutions: some View {
        if game.hasAPossibleSet() {
            return Text("\(game.solutions().description)")

        }
        return Text("No sets!")
            .fontWeight(.semibold)
    }
    
    func multiplayerScoreAndControls(forPlayerOne: Bool, havingTeamColor teamColor: Color) -> some View {
        VStack {
            Group {
                Text("SCORE: ")
                    .font(DrawingConstants.scoreFontSize)
                    .fontWeight(.heavy)
                Text(forPlayerOne ?
                     "\(game.score()) \(game.randomScoringText)"
                     : "\(game.score()) \(game.anotherRandomScoringText)" )
                    .font(DrawingConstants.scoreFontSize)
                    .fontWeight(.semibold)
                    .fixedSize()
            }
            .foregroundColor(game.highScore() == game.score() &&
                             game.highScore() != 0 ?
                             Color.orange : teamColor)
            
            Button {
                if forPlayerOne {
                    game.turnToPlayerOne()
                } else {
                    game.turnToPlayerTwo()
                }
            } label: {
                if forPlayerOne {
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
            .foregroundColor(teamColor)
            .frame(width: DrawingConstants.flagWidth)
        }
    }
    
    var completedGame: some View {
        VStack {
            Text("GAME COMPLETE!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("FINAL SCORE: \(game.score())")
                .font(.title2)
                .fontWeight(.semibold)
            Button {
                game.startNewGame()
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
        static let controlSpacing: CGFloat = 8.0
        static let scoreFontSize = Font.caption
        static let smallestFontSize = Font.footnote
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2.0
        static let notDealtHeight: CGFloat = 90
        static let notDealtWidth = notDealtHeight * aspectRatio
        static let stackXOffset = 10.0
        static let stackYOffset = 6.0
     }

}

struct CardView: View {
    let card: ShapeSetGame.Card
    let isUsingColorblindAssistance: Bool
    let isFaceUp: Bool
    
    init(card: ShapeSetGame.Card, colorblindMode: Bool = false, isFaceUp: Bool) {
        self.card = card
        self.isUsingColorblindAssistance = colorblindMode
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
    
    //===----------------------------------------------------------------------===//
    // Colorblind palette source:
    // What to consider when visualizing data for colorblind readers
    //  by Lisa Charlotte Muth
    //===----------------------------------------------------------------------===//
    func colorForTraitType(_ typeNumber: Int) -> Color {
        if !isUsingColorblindAssistance {
            switch typeNumber {
                case 0:
                    return .cyan
                case 1:
                    return .pink
                default:
                    return .green
            }
        } else {
            switch typeNumber {
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
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                            .frame(maxHeight: abs(rectangleHeight))
                    } else if card.traits[2].type == 1 {
                        WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                            .frame(maxHeight: abs(rectangleHeight))
                            .background() {
                                WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                    .fill()
                                    .foregroundColor(colorForTraitType(card.traits[3].type))
                                    //.opacity(getOpacity(card.traits[2].type))
                                    .striped(geometry: geometry)
                                    .frame(maxHeight: abs(rectangleHeight))
                            }
                        } else {
                            WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                .fill()
                                .foregroundColor(colorForTraitType(card.traits[3].type))
                                .frame(maxHeight: abs(rectangleHeight))
                    }
                case 1:
                    if card.traits[2].type == 2 {
                        Squiggle()
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                    } else if card.traits[2].type == 1 {
                        Squiggle()
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                            .background() {
                                Squiggle()
                                    .fill()
                                    .foregroundColor(colorForTraitType(card.traits[3].type))
                                    //.opacity(getOpacity(card.traits[2].type))
                                    .striped(geometry: geometry)
                            }
                    } else {
                        Squiggle()
                            .fill()
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                    }
                default:
                    if card.traits[2].type == 2 {
                        Diamond(size: 5)
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                    } else if card.traits[2].type == 1 {
                        Diamond(size:5)
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(colorForTraitType(card.traits[3].type))
                            .background() {
                                Diamond(size:5)
                                    .fill()
                                    .foregroundColor(colorForTraitType(card.traits[3].type))
                                    //.opacity(getOpacity(card.traits[2].type))
                                    .striped(geometry: geometry)
                            }
                    } else {
                        Diamond(size:5)
                            .fill()
                            .foregroundColor(colorForTraitType(card.traits[3].type))
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
