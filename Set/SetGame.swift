
//
//  Created on 3/29/22.
//

// todo make sure every trait is in same index in every card, that is rule for a game...
// also every card must be unique...
// sets must be more than 1...

import Foundation

struct SetGame {
    private(set) var deck: [CustomShapeCard] = []
    //private var hand: [CustomShapeCard]
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private var result: [Trait] = []
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    
    func isSet(_ cards: [CustomShapeCard]) -> Bool {
        if cards.count > numberOfCardsInASet || cards.count < 1 {
            return false
        }
        let traits = cards[0].traits
        for trait in traits {
            if !traitAllSameOrAllDifferent(cards, with: trait) {
                return false
            }
        }
        return true
    }
    
    // Check if an array of cards all have the same or different certain trait, or not.
    private func traitAllSameOrAllDifferent(_ cards: [CustomShapeCard], with trait: Trait) -> Bool {
        if cards.count < 2 { return true }
        // Check if the rest of the cards all have that same trait or all have a different trait.
        if cards.allSatisfy({ $0.traits[trait.index] == trait || $0.traits[trait.index] != trait }) {
            return true
        }
        return false
    }
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, setsOf numberOfCardsInASet: Int) {
        self.numberOfTraits = numberOfTraits
        self.numberOfTraitTypes = numberOfTraitTypes
        self.deckSize = Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits)))
        self.numberOfCardsInASet = numberOfCardsInASet
        createDeck(currentTrait: 0)
    }
    
    // TO-DO: Make createCardContent return a combination of traits (and probably add another param
    //         so it can keep track of where it is and doesn't make duplicate sets of traits?). Then
    //          we'll be able to make a deck of cards where each card has a unique set of traits.
    //          Then test it out and see if it works. Then continue working on it.
    
    //init(traits numberOfTraits: Int, setsOf numberOfTraitTypes: Int, _ createCardContent: (Int, Int, Int) -> [Trait]) {
        //self.numberOfCardsInASet = numberOfTraitTypes
        // Populate game deck.
        // Iterating will get every combination of traits, but we also need every combination of cards.
        /* var tempDeck: [CustomShapeCard] = []
        for i in 1...Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits))) {
            tempDeck.append(CustomShapeCard(traits:createCardContent(i, numberOfTraits, numberOfCardsInASet), id:(i*1000)))
        }
        deck = tempDeck*/
    //}

    // Recursively iterate through a multi-dimensional array of unknown size.
    private mutating func createDeck(currentTrait dimension: Int) {
        if deck.count > deckSize {
            return
        }
        if dimension >= numberOfTraits {
            deck.append(CustomShapeCard(isSelected: false, isPartOfMismatch: false, isPartOfSet: false, traits: result, id: 1000 + dimension))
            return
        }
        for i in 0..<numberOfTraitTypes {
            result.append(Trait(dimension, i))
            createDeck(currentTrait: dimension + 1)
            result.removeLast()
        }
        return
    }
    
    public func printDeck() {
        var cardCount = 0
        var traitCount = 0
        for i in 0..<deckSize {
            cardCount += 1
            print("\n")
            print("Card Count: \(cardCount)")
            for j in 0..<numberOfTraitTypes {
                traitCount += 1
                let s = String(describing: deck[i].traits[j])
                print("Trait Count: \(traitCount) Trait: \(s)")
            }
        }
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

struct Trait: Equatable, CustomStringConvertible {
    let index: Int
    let type: Int
    var description: String {
        return "\(index),\(type)"
    }
    
    init(_ trait: Int, _ type: Int) {
        self.index = trait
        self.type = type
    }
    
    
}
