
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
    
    init(_ one:Int, _ two:Int, _ three:Int) {
        game = SetGame(numberOfTraits: one, numberOfTraitTypes: two, setsOf: three)
    }
    
    func cardsInPlay() -> [Card] {
        game.cardsInPlay
    }
    
    func deck() -> [Card] {
        game.deck
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func startNewGame() {
        game.startNewGame()
        randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    }
    
    func deal() {
        _ = game.deal(wasPressed: true)
    }
    
    func score() -> Int {
        game.score
    }
    
    func highScore() -> Int {
        game.highScore
    }
    
    func scoreModifier() -> Int {
        game.scoreModifier
    }
    
    func solutions() -> [Int] {
        game.cheatIndices
    }
    
    func isSelected(_ card: Card) -> Bool {
        game.selectedCards.contains(where: { $0 == card })
    }
    
    func deckEmpty() -> Bool {
        game.deck.isEmpty
    }
    
    func complete() -> Bool {
        game.complete
    }
    
    func toggleMultiplayer() {
        game.toggleMultiplayer()
    }
    
    func isMultiplayer() -> Bool {
        game.isMultiplayer
    }
    
    func getScorePlayerTwo() -> Int {
        game.scorePlayerTwo
    }
    
    func turnToPlayerOne() {
        game.turnToPlayerOne()
    }
    
    func turnToPlayerTwo() {
        game.turnToPlayerTwo()
    }
    
    func isPlayerOneTurn() -> Bool {
        !game.turnPlayerTwo
    }
    
    func shuffle() {
        game.shuffle()
    }
    
    func hasAPossibleSet() -> Bool {
        game.setIsAvailable()
    }
    
    func lookForSet() {
        game.resetIndices()
        _ = game.lookForSet(cardIndex: 0)
    }
    
    func toggleCheatVision() {
        game.toggleCheatVision()
    }
    
    func hasCheatVision() -> Bool {
        game.cheatVision
    }
    
    func toggleColorblindAssistance() {
        isUsingColorblindAssistance.toggle()
    }
    
    func setsMade() -> [[Card]] {
        game.setsMade
    }
    
    struct Trait: Equatable, Traitable, Hashable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
