
// TODO: Make many traits or shapes, randomize which ones are chosen each new game.
// TODO: As proof of concept, add another type to all traits in the game so you can play Set 4, and make it have 4 traits if possible

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
    
    var deck: [Card] { game.deck }
    var cardsInPlay: [Card] { game.cardsInPlay }
    var setsMade: [[Card]] { game.setsMade }
    var selectedCards: [Card] { game.selectedCards }
    var deckEmpty: Bool { game.deck.isEmpty }
    
    var score: Int { game.score }
    var scoreModifier: Int { game.scoreModifier }
    var highScore: Int { game.highScore }
    
    var solutions: [Int] { game.cheatIndices }
    
    var isDone: Bool { game.isDone }
    
    var isMultiplayer: Bool { game.isMultiplayer }
    var getScorePlayerTwo: Int { game.scorePlayerTwo }
    var isPlayerOneTurn: Bool { !game.turnPlayerTwo }
    
    var hasAPossibleSet: Bool { game.setIsAvailable() }
    var hasCheatVision: Bool { game.cheatVision }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func startNewGame() {
        game.startNewGame()
        randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    }
    
    func clearSelectedSet() {
        game.clearSelectedSet()
    }
    
    func deal() {
        _ = game.deal(wasPressed: true)
    }
    
    func isSelected(_ card: Card) -> Bool {
        game.selectedCards.contains(where: { $0 == card })
    }
    
    func toggleMultiplayer() {
        game.toggleMultiplayer()
    }
    
    func turnToPlayerOne() {
        game.turnToPlayerOne()
    }
    
    func turnToPlayerTwo() {
        game.turnToPlayerTwo()
    }
    
    func shuffle() {
        game.shuffle()
    }
    
    func lookForSet() {
        game.resetIndices()
        _ = game.lookForSet(cardIndex: 0)
    }
    
    var hasASetSelected: Bool { return !game.selectedCards.isEmpty &&
                                       (game.selectedCards[0].isPartOfSet == true.intValue) }
    
    func toggleCheatVision() {
        game.toggleCheatVision()
    }
    
    func toggleColorblindAssistance() {
        isUsingColorblindAssistance.toggle()
    }
    
    struct Trait: Equatable, Traitable, Hashable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
