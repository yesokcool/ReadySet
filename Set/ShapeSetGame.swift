
//
//  Created on 3/29/22.
//

// TODO: Make many traits or shapes, randomize which ones are chosen each new game.
// TODO: As proof of concept, add another type to all traits in the game so you can play Set 4.
// TODO: Could call this Set-N Game.

import Foundation
import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<Trait>.CustomShapeCard
    
    @Published private var game: SetGame<Trait>
    
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
        return game.setsMade.count * 5
    }
    
    func isSelected(_ card: Card) -> Bool {
        return game.selectedCards.contains(where: { $0 == card })
    }
    
    struct Trait: Equatable, Traitable {
        let type: Int
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
