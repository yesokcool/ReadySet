
// TODO: Make many traits or shapes, randomize which ones are chosen each new game.
// TODO: As proof of concept, add another type to all traits in the game so you can play Set 4.
// TODO: Could call this Set-N Game.

import Foundation
import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<Trait>.CustomShapeCard
    
    @Published private var game: SetGame<Trait>
    @Published private var cheatMode: Bool = false
    
    init(_ one:Int, _ two:Int, _ three:Int) {
        game = SetGame(numberOfTraits: one, numberOfTraitTypes: two, setsOf: three)
    }
    
    func getCardsInPlay() -> [Card] {
        return game.cardsInPlay
    }
    
    func getDeck() -> [Card] {
        return game.deck
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    func newGame() {
        game.newGame()
    }
    
    func dealThree() {
        _ = game.dealThree()
    }
    
    func getScore() -> Int {
        return game.score
    }
    
    func getHighScore() -> Int {
        return game.highScore
    }
    
    func getScoreModifier() -> Int {
        return game.scoreModifier
    }
    
    func setAvailable() -> Bool {
        return game.checkIfSetIsAvailable(cardIndex: 0)
    }
    
    func cheatIndices() -> [Int] {
        return game.cheatIndices
    }
    
    func isSelected(_ card: Card) -> Bool {
        return game.selectedCards.contains(where: { $0 == card })
    }
    
    func deckEmpty() -> Bool {
        return game.deck.isEmpty
    }
    
    func gameComplete() -> Bool {
        return game.gameComplete
    }
    
    func shuffle() {
        game.shuffle()
    }
    
    func cheat() -> Bool {
        return cheatMode
    }
    
    func cheatToggle() {
        cheatMode.toggle()
    }
    
    struct Trait: Equatable, Traitable, Hashable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
