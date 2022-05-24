
//
//  Created on 3/29/22.
//

// todo make many traits or shapes, randomize which ones are chosen each new game

import Foundation
import SwiftUI

class ShapeSetGame: ObservableObject {
    typealias Card = SetGame<Trait>.CustomShapeCard
    
    @Published private var game: SetGame<Trait>
    
    init(_ one:Int, _ two:Int, _ three:Int) {
        game = SetGame(numberOfTraits: one, numberOfTraitTypes: two, setsOf: three)
    }
    
    //@Published private var theme: Theme<String>
    //@Published private var model: MatchGame<String>
    //@Published private var themes: [Theme<String>]
    
    func getCardsInPlay() -> [Card] {
        return game.cardsInPlay
    }
    
    func getDeck() -> [Card] {
        return game.deck
    }
    
    func choose(_ card: Card) {
        game.choose(card)
    }
    
    struct Trait: Equatable, Traitable {
        let type: Int
        /*var description: String {
            return "\(type)"
        }*/
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }
}
