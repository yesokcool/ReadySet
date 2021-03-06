
import Foundation
import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<Trait>.CustomShapeCard
    
    @Published private var game: SetGame<Trait>
    @Published private(set) var isUsingColorblindAssistance: Bool = false
    private(set) var randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
    private(set) var anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
    private(set) var randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, withSetsOf numberOfCardsInASet: Int) {
        game = SetGame(numberOfTraits: numberOfTraits, numberOfTraitTypes: numberOfTraitTypes, withSetsOf: numberOfCardsInASet)
    }
    
    struct Trait: Equatable, Traitable, Hashable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
    
    // Game Definitions
    var isDone: Bool { game.isDone }
    
    // Card management
    var deck: [Card] { game.deck }
    var cardsInPlay: [Card] { game.cardsInPlay }
    var setsMade: [[Card]] { game.setsMade }
    var selectedCards: [Card] { game.selectedCards }
    var deckEmpty: Bool { game.deck.isEmpty }
    
    // Scoring
    var score: Int { game.score }
    var scoreModifier: Int { game.scoreModifier }
    var highScore: Int { game.highScore }
    
    // Multiplayer
    var isMultiplayer: Bool { game.isMultiplayer }
    var scorePlayerTwo: Int { game.scorePlayerTwo }
    var isPlayerOneTurn: Bool { !game.turnPlayerTwo }
    
    // Cheat
    var solutions: [Int] { game.cheatIndices }
    var hasCheatVision: Bool { game.cheatVision }
    
    // Utility
    var hasAPossibleSet: Bool { game.setIsAvailable() }
    
    // ====-----------Game Management-----------==== //
    func startNewGame() {
        game.startNewGame()
        randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    }
    
    //====-----------Card Management-----------====//
    func deal() {
        _ = game.deal(wasPressed: true)
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func clearSelectedSet() {
        game.clearSelectedSet()
    }
    
    func isSelected(_ card: Card) -> Bool {
        game.selectedCards.contains(where: { $0 == card })
    }
    
    func shuffle() {
        game.shuffle()
    }
    
    //====--------------Multiplayer--------------====//
    func toggleMultiplayer() {
        game.toggleMultiplayer()
    }
    
    func turnToPlayerOne() {
        game.turnToPlayerOne()
    }
    
    func turnToPlayerTwo() {
        game.turnToPlayerTwo()
    }
    
    //====----------------Utility----------------====//
    func lookForSet() {
        game.resetIndices()
        _ = game.lookForSet(cardIndex: 0)
    }
    
    var hasASetSelected: Bool { return !game.selectedCards.isEmpty &&
                                       (game.selectedCards[0].isPartOfSet == true.intValue) }
    
    //====-----------------Cheat-----------------====//
    func toggleCheatVision() {
        game.toggleCheatVision()
    }
    
    //====-------------Accessibility-------------====//
    func toggleColorblindAssistance() {
        isUsingColorblindAssistance.toggle()
    }
}
