
//
//  Created on 3/29/22.
//

// todo make sure every trait is in same index in every card, that is rule for a game...
// also every card must be unique...
// sets must be more than 1...

import Foundation

struct SetGame {
    private let deck: [CustomShape]
    private var hand: [CustomShape]
    private let cardsInASet: Int
    
    func isSet(_ cards: [CustomShape]) -> Bool {
        if cards.count > cardsInASet || cards.count < 1 {
            return false
        }
        
        let traits = cards[0].traits
        for trait in traits {
            if !allSame(cards, with: trait) || !allDifferent(cards, with: trait) {
                return false
            }
        }
        
        return true
    }
    
    private func allSame(_ cards: [CustomShape], with trait: Trait) -> Bool {
        if cards.count < 2 { return true }

        if let indexOfSelectedTrait = cards[0].traits.firstIndex(where: { $0.name == trait.name }) {
            let firstTrait = cards[0].traits[indexOfSelectedTrait]
        
            return cards.dropFirst().allSatisfy({ $0.traits[indexOfSelectedTrait] == firstTrait })
        }
        
        return false
    }
    
    private func allDifferent(_ cards: [CustomShape], with trait: Trait) -> Bool {
        if cards.count < 2 { return false }

        if let indexOfSelectedTrait = cards[0].traits.firstIndex(where: { $0.name == trait.name }) {
            let firstTrait = cards[0].traits[indexOfSelectedTrait]
            
            return cards.dropFirst().allSatisfy({ $0.traits[indexOfSelectedTrait] != firstTrait })
        }
        
        return false
    }
}

struct CustomShape {
    let traits: [Trait]
}

struct Trait: Equatable {
    let name: String
    let trait: Int
    
    init(_ name: String, _ trait: Int) {
        self.name = name
        self.trait = trait
    }
}
