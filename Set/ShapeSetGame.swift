
//
//  Created on 3/29/22.
//

// todo make many traits or shapes, randomize which ones are chosen each new game

import Foundation

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame.CustomShapeCard
    
    private var game: SetGame
    
    init(_ one:Int, _ two:Int, _ three:Int) {
        game = SetGame(numberOfTraits: one, numberOfTraitTypes: two, setsOf: three)
    }
    
    //@Published private var theme: Theme<String>
    //@Published private var model: MatchGame<String>
    //@Published private var themes: [Theme<String>]
    
    func getCardsInPlay() -> [Card] {
        return game.cardsInPlay
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
}
