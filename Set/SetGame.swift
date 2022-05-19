
//
//  Created on 3/29/22.
//

import Foundation

struct SetGame {
    private(set) var deck: [CustomShapeCard] = []
    private(set) var cardsInPlay: [CustomShapeCard] = []
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private var result: [Trait] = []
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    private var chosenCards: [Int] = []
    private(set) var setsMade: [[Int]] = []
    
    // todo might not need setsMade variable
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, setsOf numberOfCardsInASet: Int) {
        self.numberOfTraits = numberOfTraits
        self.numberOfTraitTypes = numberOfTraitTypes
        self.deckSize = Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits)))
        self.numberOfCardsInASet = numberOfCardsInASet
        createDeck(currentTrait: 0)
        deck.shuffle()
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
    
    // todo could be deal x instead, perhaps
    
    // Deals 3 cards from the shuffled deck.
    mutating func dealThree() -> Bool {
        for _ in 0..<3 {
            if deck.count > 0 {
                cardsInPlay.append(deck.removeFirst())
            }
            else {
                return false
            }
        }
        return true
    }
    
    mutating func newGame() {
        deck = []
        result = []
        cardsInPlay = []
        setsMade = []
        chosenCards = []
        createDeck(currentTrait: 0)
    }
    
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = deck.firstIndex(of: card),
            !deck[chosenIndex].isPartOfSet {
            if deck[chosenIndex].isSelected {
                deck[chosenIndex].isSelected = false
            }
            else if (!deck[chosenIndex].isPartOfSet) {
                print("Choosing \(card)!")
                deck[chosenIndex].isSelected = true
                chosenCards.append(chosenIndex)
                if chosenCards.count >= numberOfCardsInASet {
                    if isSet(chosenCards) {
                        setsMade.append(chosenCards)
                        for c in chosenCards {
                            deck[c].isPartOfSet = true
                            // todo we'll see if removing from deck is okay
                            deck.remove(at: c)
                        }
                    }
                chosenCards = []
                }
            }
        }
    }
    
    private mutating func isSet(_ setOfCards: [Int]) -> Bool {
        if setOfCards.count > numberOfCardsInASet
            || setOfCards.count < 1 {
            return false
        }
        let traits = deck[setOfCards[0]].traits
        for (traitIndex, _) in traits.enumerated() {
            if !traitAllSameOrAllDifferent(setOfCards, with: traitIndex) {
                return false
            }
        }
        
        if !deck.isEmpty {
            dealThree()
        }
            
        return true
    }
    
    // Check if an array of cards all have the same or different selected trait, or not.
    private func traitAllSameOrAllDifferent(_ setOfCardIndicies: [Int], with selectedTrait: Int) -> Bool {
        if setOfCardIndicies.count < 2 { return true }
        
        var set: [Int] = []
        for i in setOfCardIndicies {
            set.append(deck[i].traits[selectedTrait].type)
        }
        
        return Set(set).count == 1 || Set(set).count == set.count
    }
    
    public func printDeck() {
        var cardCount = 0
        for i in 0..<deckSize {
            print("\n")
            print("Card Count: \(cardCount)")
            for j in 0..<numberOfTraits {
                let s = String(describing: deck[i].traits[j])
                print("Trait: \(s)")
            }
            cardCount += 1
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
        let type: Int
        var description: String {
            return "\(type)"
        }
        
        init(_ trait: Int, _ type: Int) {
            self.type = type
        }
    }

}
