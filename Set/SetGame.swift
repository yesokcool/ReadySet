
//
//  Created on 3/29/22.
//

import Foundation

struct SetGame<CardContent> where CardContent: Equatable & Traitable {
    private(set) var deck: [CustomShapeCard] = []
    private(set) var fixedDeck: [CustomShapeCard] = []
    private(set) var cardsInPlay: [CustomShapeCard] = []
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private(set) var result: [CardContent] = []
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    private(set) var setsMade: [[CustomShapeCard]] = []
    private(set) var selectedCards: [CustomShapeCard] = []
    private(set) var id: Int = 0
    
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
            id += 1
            deck.append(CustomShapeCard(isPartOfSet: false,
                                        isSelected: false,
                                        traits: result, id: id))
            return
        }
        for i in 0..<numberOfTraitTypes {
            result.append(CardContent(dimension, i))
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
        createDeck(currentTrait: 0)
        deck.shuffle()
        fixedDeck = deck
    }
    
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = cardsInPlay.firstIndex(of: card),
            !cardsInPlay[chosenIndex].isPartOfSet {
            if selectedCards.contains(cardsInPlay[chosenIndex]) {
                selectedCards.remove(at: selectedCards.firstIndex(of: cardsInPlay[chosenIndex])!)
                cardsInPlay[chosenIndex].isSelected = false
            }
            else if (!cardsInPlay[chosenIndex].isPartOfSet) {
                print("Choosing \(card)!")
                cardsInPlay[chosenIndex].isSelected = true
                selectedCards.append(cardsInPlay[chosenIndex])
                if selectedCards.count >= numberOfCardsInASet {
                    if isSet(selectedCards) {
                        setsMade.append(selectedCards)
                        for c in selectedCards {
                            fixedDeck[fixedDeck.firstIndex(of: c)!].isPartOfSet = true
                            // todo we'll see if removing from deck is okay
                            cardsInPlay.remove(at: cardsInPlay.firstIndex(of: c)!)
                        }
                    }
                    selectedCards = []
                }
            }
        }
    }
    
    private mutating func isSet(_ setOfCards: [CustomShapeCard]) -> Bool {
        if setOfCards.count > numberOfCardsInASet
            || setOfCards.count < 1 {
            return false
        }
        let traits = setOfCards[0].traits
        for (traitIndex, _) in traits.enumerated() {
            if !traitAllSameOrAllDifferent(setOfCards, with: traitIndex) {
                return false
            }
        }
        
        if !deck.isEmpty {
            _ = dealThree()
        }

        return true
    }
    
    // Check if an array of cards all have the same or different selected trait, or not.
    private func traitAllSameOrAllDifferent(_ setOfCards: [CustomShapeCard], with selectedTrait: Int) -> Bool {
        if setOfCards.count < 2 { return true }
        
        var set: [Int] = []
        for card in setOfCards {
            set.append(card.traits[selectedTrait].type)
        }
        
        return Set(set).count == 1 || Set(set).count == set.count
    }
    
    /*public func printDeck() {
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
    }*/
    
    struct CustomShapeCard: Identifiable, Equatable {
        var isPartOfSet = false
        var isSelected = false
        let traits: [CardContent]
        let id: Int
    }
}
