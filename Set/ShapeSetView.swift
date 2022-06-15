
// TODO: Add some ways to speed up the game. Like if you match multiple sets quickly, you get a special vision that shows you sets to match and matching them has an intense POWERFUL-feeling animation, screen shake, pop up text saying quake-like stuff like unstoppable, particles of randomized emojis like cows etc. And if you keep matching fast, it keeps the mode going. Call this READY, SET, and have it flash on screen, kind of like Super Hot.
// TODO: Add animation when breaking high score
// TODO: Add shuffle button for fun?
// colorblind mode in discard pile
// larger control buttons
// more definition on deck maybe an offset for 3 cards on top
// deck of cards a bit larger to match discard pile, only do this after trying offset
// player 2 score going up when not their turn
// text shadow / glow effect, maybe the rainbow effect
// cards should be dealt out over scroll view
// stripes disappear at largest size

import SwiftUI

struct ShapeSetView: View {
    @ObservedObject var game: ShapeSetGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        if !game.isDone {
            VStack {
                if game.isMultiplayer {
                    multiplayerScoreAndControls(forPlayerOne: false, havingTeamColor: .mint)
                        .rotationEffect(Angle.degrees(180))
                } else {
                    scoreboard
                    Divider()
                        .overlay(.blue)
                }
                
                if !game.isMultiplayer {
                    scoreModifier
                    Divider()
                        .overlay(.blue)
                }
                
                if game.hasCheatVision {
                    showSolutions
                        .font(DrawingConstants.smallestFontSize)
                }
                
                dealtOutCards
                    .padding(.bottom, -120)
            
                Spacer()
                
                VStack {
                    if game.isMultiplayer {
                        multiplayerScoreAndControls(forPlayerOne: true, havingTeamColor: .blue)
                    }
                    bottomControls
                }
            }
            .foregroundColor(.primary)
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
        let delay = (Double(index) * 0.02) * (CardConstants.totalDealDuration)
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    var dealtOutCards: some View {
        AspectVGrid(items: game.cardsInPlay, aspectRatio: 2/3) { card in
            if isNotDealt(card) {
                Color.clear
            } else {
                CardView(card: card, colorblindMode: game.isUsingColorblindAssistance, isFaceUp: isFaceUp(card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.identity)
                    //.animation(Animation.spring(), value: card.isPartOfSet)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            game.choose(card)
                        }
                }
            }
        }
        
    }
    
    var deckOfCards: some View {
        ZStack {
            ForEach(game.deck.filter( { isNotDealt($0) } ).reversed()) { card in
                CardView(card: card, isFaceUp: isFaceUp(card) )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .onTapGesture {
            // starting deal
            if game.cardsInPlay.count == 0 {
                for i in 0..<12 {
                    withAnimation(dealAnimation(for: game.deck[game.deck.count - 1], index: i) ) {
                        game.clearSelectedSet()
                        game.deal()
                        deal(game.cardsInPlay[game.cardsInPlay.count - 1])
                    }
                } // normal deal 3
            } else {
                var justMadeASet: Bool
                if game.hasASetSelected {
                    justMadeASet = true
                } else {
                    justMadeASet = false
                }
                withAnimation(Animation.easeInOut) {
                    game.clearSelectedSet()
                }
                for i in 0..<3 {
                    withAnimation(dealAnimation(for: game.deck[game.deck.count - 1], index: i).delay(justMadeASet ? 0.5 : 0) ){
                        game.deal()
                        deal(game.cardsInPlay[game.cardsInPlay.count - 1])
                    }
                }
            }
            for card in game.cardsInPlay {
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
            ForEach(0 ..< game.setsMade.count, id: \.self) { i in
                ForEach(game.setsMade[i]) { card in
                        CardView(card: card, colorblindMode: game.isUsingColorblindAssistance, isFaceUp: isFaceUp(card))
                            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                            .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                            .offset(x: cardOffset(forCardAtIndex: game.setsMade[i].firstIndex(of: card)!, along: Axis.horizontal),
                                    y: cardOffset(forCardAtIndex: game.setsMade[i].firstIndex(of: card)!, along: Axis.vertical))
                            .opacity(i >= game.setsMade.count - 2 ? 100 : 0)
                }
            }
        }
        .frame(width: CardConstants.notDealtWidth, height: CardConstants.notDealtHeight)
        .padding(.horizontal)
    }

    /*private func zIndex(of card: ShapeSetGame.Card) -> Double {
        -Double(game.deck().firstIndex(where: { $0.id == card.id}) ?? 0)
    }*/
    
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
            Spacer()
            discardedCardPile
            Button {
                game.startNewGame()
                dealt = []
                faceUp = []
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DrawingConstants.controlButtonWidth)
            }
            pushButton(withImage: Image(systemName: "circle.hexagongrid.circle.fill"),
                              whenPressedIs: Image(systemName: "circle.hexagongrid.circle"),
                              withImageWidth: DrawingConstants.controlButtonWidth,
                              whichDoes: game.toggleColorblindAssistance,
                              checksWith: game.isUsingColorblindAssistance,
                              color1: .blue)
            pushButton(withImage: Image(systemName: "person.2.circle.fill"),
                              whenPressedIs: Image(systemName: "person.2.circle"),
                              withImageWidth: DrawingConstants.controlButtonWidth,
                              whichDoes: game.toggleMultiplayer,
                              checksWith: game.isMultiplayer,
                              color1: .blue)
            pushButton(withImage: Image(systemName: "magnifyingglass.circle.fill"),
                              whenPressedIs: Image(systemName: "magnifyingglass.circle"),
                              withImageWidth: DrawingConstants.controlButtonWidth,
                              whichDoes: game.toggleCheatVision,
                              checksWith: game.hasCheatVision,
                              color1: .red, color2: .blue)
            deckOfCards
            Spacer()
        }
        .padding(.horizontal, 35.0)
        .padding(.vertical, 10.0)
        .foregroundColor(.blue)
    }
    
    func pushButton(withImage buttonImage: Image, whenPressedIs buttonImageWhenPressed: Image, withImageWidth width: CGFloat,
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
                    .frame(width: width)
                :
                buttonImageWhenPressed
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color2 ?? color1)
                    .frame(width: width)
            }
        }
    }
        
    var scoreboard: some View {
        HStack {
                VStack {
                    Text("HIGH SCORE")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.semibold)
                    Text("\(game.highScore) \n\(game.anotherRandomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .fixedSize()
                }
                .foregroundColor(game.highScore == game.score &&
                                 game.highScore != 0 ?
                                 Color.orange : Color.blue)
                .multilineTextAlignment(.center)
                
            Spacer()
            VStack {
                    Group {
                    Text("SCORE")
                            .font(DrawingConstants.scoreFontSize)
                            .fontWeight(.semibold)
                        Text("\(game.score) \n\(game.randomScoringText)")
                        .font(DrawingConstants.scoreFontSize)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .fixedSize()
                }
                .foregroundColor(game.highScore == game.score &&
                                 game.highScore != 0 ?
                                 Color.orange : Color.blue)
                
            }
        }
        .padding(.horizontal, 40.0)
        .padding(.top, 5.0)
    }
    
    var scoreModifier: some View {
        Text("\(game.scoreModifier) \(game.randomScoreModifierText)")
            .font(DrawingConstants.scoreFontSize)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding(.all, 6.0)
            .multilineTextAlignment(.center)
    }
    
    var showSolutions: some View {
        if game.hasAPossibleSet {
            return Text("\(game.solutions.description)")

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
                     "\(game.score) \(game.randomScoringText)"
                     : "\(game.score) \(game.anotherRandomScoringText)" )
                    .font(DrawingConstants.scoreFontSize)
                    .fontWeight(.semibold)
                    .fixedSize()
            }
            .foregroundColor(game.highScore == game.score &&
                             game.highScore != 0 ?
                             Color.orange : teamColor)
            
            pushButton(withImage: Image(systemName: "flag.circle"),
                              whenPressedIs: Image(systemName: "flag.circle.fill"),
                              withImageWidth: DrawingConstants.flagWidth,
                              whichDoes: (forPlayerOne ? game.turnToPlayerOne : game.turnToPlayerTwo),
                              checksWith: (forPlayerOne ? !game.isPlayerOneTurn : game.isPlayerOneTurn),
                              color1: teamColor)
        }
    }
    
    var completedGame: some View {
        VStack {
            Text("GAME COMPLETE!")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("FINAL SCORE: \(game.score)")
                .font(.title2)
                .fontWeight(.semibold)
            Button {
                game.startNewGame()
                dealt = []
                faceUp = []
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
            .cardify(card: card, isFaceUp: isFaceUp, color: colorForTraitType(card.traits[3].type))
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
        let cornerRadiusRectangle: CGFloat = geometry.size.width * CardConstants.cornerRadiusRectangleMultiplier
        let lineWidth: CGFloat = geometry.size.width * CardConstants.lineWidthMultiplier
        
        ForEach(0..<card.traits[0].type + 1, id: \.self) { _ in
            switch card.traits[1].type {
                case 0:
                    if card.traits[2].type == 2 {
                        WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: true)
                    } else if card.traits[2].type == 1 {
                        WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: true)
                            .background() {
                                WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                    .fill()
                                    .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                                   isSelected: card.isSelected, isStriped: true, isRectangle: true)
                            }
                        } else {
                            WideRoundedRectangle(cornerRadius: cornerRadiusRectangle)
                                .fill()
                                .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                               isSelected: card.isSelected, isStriped: false, isRectangle: true)
                    }
                case 1:
                    if card.traits[2].type == 2 {
                        Squiggle()
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                    } else if card.traits[2].type == 1 {
                        Squiggle()
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                            .background() {
                                Squiggle()
                                    .fill()
                                    .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                                   isSelected: card.isSelected, isStriped: true, isRectangle: false)
                            }
                    } else {
                        Squiggle()
                            .fill()
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                    }
                default:
                    if card.traits[2].type == 2 {
                        Diamond(size: 5)
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                    } else if card.traits[2].type == 1 {
                        Diamond(size:5)
                            .stroke(lineWidth: lineWidth)
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                            .background() {
                                Diamond(size:5)
                                    .fill()
                                    .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                                   isSelected: card.isSelected, isStriped: true, isRectangle: false)
                            }
                    } else {
                        Diamond(size:5)
                            .fill()
                            .traitColorize(color: colorForTraitType(card.traits[3].type), geometry: geometry,
                                           isSelected: card.isSelected, isStriped: false, isRectangle: false)
                    }
            }
        }
    }
    
    struct CardConstants {
        static let cornerRadiusRectangleMultiplier: CGFloat = 0.3
        static let lineWidthMultiplier: CGFloat = 0.03
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ShapeSetGame(numberOfTraits: 4, numberOfTraitTypes: 3, withSetsOf: 3)
        return ShapeSetView(game: game).preferredColorScheme(.light)
    }
}
