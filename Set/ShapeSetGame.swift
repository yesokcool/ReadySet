
// TODO: Make many traits or shapes, randomize which ones are chosen each new game.
// TODO: As proof of concept, add another type to all traits in the game so you can play Set 4, and make it have 4 traits if possible

import Foundation
import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<Trait>.CustomShapeCard
    
    @Published private var game: SetGame<Trait>
    @Published private(set) var colorblindMode: Bool = false
    private(set) var randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
    private(set) var anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
    private(set) var randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    
    init(_ one:Int, _ two:Int, _ three:Int) {
        game = SetGame(numberOfTraits: one, numberOfTraitTypes: two, setsOf: three)
    }
    
    func getCardsInPlay() -> [Card] {
        game.cardsInPlay
    }
    
    func getDeck() -> [Card] {
        game.deck
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func newGame() {
        game.newGame()
        randomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        anotherRandomScoringText = SillyText.scoringText[Int.random(in: 0 ..< SillyText.scoringText.count)]
        randomScoreModifierText = SillyText.scoringModifier[Int.random(in: 0 ..< SillyText.scoringModifier.count)]
    }
    
    func deal() {
        _ = game.deal(wasPressed: true)
    }
    
    func getScore() -> Int {
        game.score
    }
    
    func getHighScore() -> Int {
        game.highScore
    }
    
    func getScoreModifier() -> Int {
        game.scoreModifier
    }
    
    func cheatIndices() -> [Int] {
        game.cheatIndices
    }
    
    func isSelected(_ card: Card) -> Bool {
        game.selectedCards.contains(where: { $0 == card })
    }
    
    func deckEmpty() -> Bool {
        game.deck.isEmpty
    }
    
    func gameComplete() -> Bool {
        game.gameComplete
    }
    
    func twoPlayerMode() {
        game.twoPlayerToggle()
    }
    
    func twoPlayers() -> Bool {
        game.twoPlayerMode
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
    
    func setAvailable() -> Bool {
        game.setAvailable()
    }
    
    func checkIfSetIsAvailable() -> Bool {
        game.resetIndices()
        return game.checkIfSetIsAvailable(cardIndex: 0)
    }
    
    func cheatToggle() {
        game.cheatModeToggle()
    }
    
    func cheatMode() -> Bool {
        game.cheatMode
    }
    
    func colorblindToggle() {
        colorblindMode.toggle()
    }
    
    func getSetsMade() -> [[Card]] {
        game.setsMade
    }
    
    struct Trait: Equatable, Traitable, Hashable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
