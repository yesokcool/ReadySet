
//
//  Created on 3/29/22.
//

import Foundation

struct SetGame {
    private(set) var deck: [CustomShapeCard] = []
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private var result: [Trait] = []
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    private var chosenCards: [CustomShapeCard] = []
    private(set) var setsMade: [[CustomShapeCard]] = []
    
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
    
    // todo might not need setsMade variable
    
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = deck.firstIndex(of: card), !deck[chosenIndex].isPartOfSet {
            if deck[chosenIndex].isSelected {
                deck[chosenIndex].isSelected = false
            }
            else {
                chosenCards.append(card)
                deck[chosenIndex].isSelected = true
                if chosenCards.count >= numberOfCardsInASet {
                    if isSet(chosenCards) {
                        setsMade.append(chosenCards)
                        for c in chosenCards {
                            deck[deck.firstIndex(of: c)!].isPartOfSet = true
                        }
                    }
                chosenCards = []
                }
            }
        }
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

    // todo actual id
    // todo it being void and using return, dunno if great style
    
    // Recursively iterate through a multi-dimensional array of unknown size.
    private mutating func createDeck(currentTrait dimension: Int) {
        if deck.count > deckSize {
            return
        }
        if dimension >= numberOfTraits {
            deck.append(CustomShapeCard(isSelected: false, isPartOfMismatch: false,
                        isPartOfSet: false, traits: result, id: 1000 + dimension))
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

struct CustomShapeCard: Identifiable, Equatable {
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
