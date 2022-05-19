
//
//  Created on 3/29/22.
//

// todo make many traits or shapes, randomize which ones are chosen each new game

import Foundation

struct ShapeSetGame {
    
    init() {
        var game = SetGame(numberOfTraits: 4, numberOfTraitTypes: 3, setsOf: 3)
        game.printDeck()
        game.choose(game.deck[0])
        game.choose(game.deck[1])
        game.choose(game.deck[2])
        print(game.setsMade)
        game.choose(game.deck[3])
        game.choose(game.deck[4])
        game.choose(game.deck[6])
        print(game.setsMade)
        game.dealThree()
        print(game.cardsInPlay)

    }

    
}
