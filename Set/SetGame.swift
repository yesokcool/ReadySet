
//
//  Created on 3/29/22.
//

// todo make sure every trait is in same index in every card, that is rule for a game...
// also every card must be unique...
// sets must be more than 1...

import Foundation

struct SetGame {
    private let deck: [CustomShapeCard]
    //private var hand: [CustomShapeCard]
    private let numberOfCardsInASet: Int
    
    func isSet(_ cards: [CustomShapeCard]) -> Bool {
        if cards.count > numberOfCardsInASet || cards.count < 1 {
            return false
        }
        let traits = cards[0].traits
        for trait in traits {
            if !traitAllSameOrAllDifferent(cards, with: trait) { return false }
        }
        return true
    }
    
    // Check if an array of cards all have the same or different certain trait, or not.
    private func traitAllSameOrAllDifferent(_ cards: [CustomShapeCard], with trait: Trait) -> Bool {
        if cards.count < 2 { return true }
        // Take the first card and find the index where the trait occurs.
        if let indexOfSelectedTrait = cards[0].traits.firstIndex(where: { $0.trait == trait.trait }) {
            let firstTrait = cards[0].traits[indexOfSelectedTrait]
            // Check if the rest of the cards all have that same trait or all have a different trait.
            if cards.dropFirst().allSatisfy({ $0.traits[indexOfSelectedTrait] == firstTrait ||
                $0.traits[indexOfSelectedTrait] != firstTrait}) {
                return true
            }
        }
        return false
    }
    
    // TO-DO: Make createCardContent return a combination of traits (and probably add another param
    //         so it can keep track of where it is and doesn't make duplicate sets of traits?). Then
    //          we'll be able to make a deck of cards where each card has a unique set of traits.
    //          Then test it out and see if it works. Then continue working on it.
    
    init(traits numberOfTraits: Int, setsOf numberOfTraitTypes: Int, _ createCardContent: (Int, Int) -> [Trait]) {
        self.numberOfCardsInASet = numberOfTraitTypes
        // Populate game deck.
        // Iterating with i and j will get every combination of traits, but we need every combination of cards.
        var tempDeck: [CustomShapeCard] = []
        for i in 1...Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits))) {
            tempDeck.append(CustomShapeCard(traits:createCardContent(numberOfTraits, numberOfCardsInASet), id:(i*1000)))
        }
        deck = tempDeck
    }
}

// Traits must always be in the same index for every card?
struct CustomShapeCard: Identifiable {
    var isSelected = false
    var isPartOfMismatch = false
    var isPartOfSet = false
    let traits: [Trait]
    let id: Int
}

struct Trait: Equatable {
    let trait: Int
    let type: Int
    
    init(_ trait: Int, _ type: Int) {
        self.trait = trait
        self.type = type
    }
}
