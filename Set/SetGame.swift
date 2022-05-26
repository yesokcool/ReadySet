
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
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, setsOf numberOfCardsInASet: Int) {
        self.numberOfTraits = numberOfTraits
        self.numberOfTraitTypes = numberOfTraitTypes
        self.deckSize = Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits)))
        self.numberOfCardsInASet = numberOfCardsInASet
        createDeck(currentTrait: 0)
        deck.shuffle()
    }
    
    // TODO: Vod function just returning? Good style?
    // Recursively iterate through a multi-dimensional array of unknown size.
    private mutating func createDeck(currentTrait dimension: Int) {
        if deck.count > deckSize {
            return
        }
        if dimension >= numberOfTraits {
            id += 1
            deck.append(CustomShapeCard(traits: result, id: id))
            return
        }
        for i in 0..<numberOfTraitTypes {
            result.append(CardContent(dimension, i))
            createDeck(currentTrait: dimension + 1)
            result.removeLast()
        }
        return
    }
    
    // TODO: Perhaps could be deal any the game wants to.
    
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
    
    // TODO: Set it back to shuffle when done debugging.
    mutating func newGame() {
        deck = []
        result = []
        cardsInPlay = []
        setsMade = []
        createDeck(currentTrait: 0)
        //deck.shuffle()
        fixedDeck = deck
    }
    
    // TODO: Currently using both isSelected and selectedCards.
    // Perhaps possible to just need to use one of these
    // TODO: Maybe make extension more readable and replace intValue
    // for something else.
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = cardsInPlay.firstIndex(of: card),
           cardsInPlay[chosenIndex].isPartOfSet != true.intValue {
            if selectedCards.count >= numberOfCardsInASet {
                if selectedCards[0].isPartOfSet == true.intValue {
                    for c in selectedCards {
                        // todo we'll see if removing from deck is okay
                        cardsInPlay.remove(at: cardsInPlay.firstIndex(of: c)!)
                        // this doesnt matter cus removed -> cardsInPlay[cardsInPlay.firstIndex(of: c)!].isSelected = false
                    }
                    selectedCards = []
                }
                else {
                    for c in selectedCards {
                        // todo we'll see if removing from deck is okay
                        let i = cardsInPlay.firstIndex(of: c)!
                        cardsInPlay[i].isSelected = false
                        cardsInPlay[i].isPartOfSet = false.none
                    }
                    selectedCards = []
                    cardsInPlay[chosenIndex].isSelected = true
                    selectedCards.append(cardsInPlay[chosenIndex])
                }
            }
            else {
                if (selectedCards.contains(cardsInPlay[chosenIndex])) {
                    selectedCards.remove(at: selectedCards.firstIndex(of: cardsInPlay[chosenIndex])!)
                }
                else {
                    print("Choosing \(card)!")
                    cardsInPlay[chosenIndex].isSelected = true
                    selectedCards.append(cardsInPlay[chosenIndex])
                    if selectedCards.count >= numberOfCardsInASet {
                        if isSet(selectedCards) {
                            print("IS A SET!")
                            setsMade.append(selectedCards)
                            for (i, c) in selectedCards.enumerated() {
                                // todo we'll see if removing from deck is okay
                                cardsInPlay[cardsInPlay.firstIndex(of: c)!].isPartOfSet = true.intValue
                                selectedCards[i].isPartOfSet = true.intValue
                            }
                        }
                        else {
                            for (i, c) in selectedCards.enumerated() {
                                cardsInPlay[cardsInPlay.firstIndex(of: c)!].isPartOfSet = false.intValue
                                selectedCards[i].isPartOfSet = false.intValue
                            }
                        }
                    }
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
        
        // For every trait that exists in the game and is present in every card,
        // check if the trait of the first card has the same type or different as
        // the trait in every other card.
        for (traitIndex, _) in traits.enumerated() {
            if !traitAllSameOrAllDifferentType(setOfCards, with: traitIndex) {
                return false
            }
        }
        
        if !deck.isEmpty {
            _ = dealThree()
        }

        return true
    }
    
    // Check if an array of cards all have the same or different selected trait, or not.
    private func traitAllSameOrAllDifferentType(_ setOfCards: [CustomShapeCard], with selectedTrait: Int) -> Bool {
        if setOfCards.count < 2 { return true }
        
        // Go through the set of cards. For every card, take the selected trait's type
        // and append it to the array of trait types.
        var traitTypes: [Int] = []
        for card in setOfCards {
            traitTypes.append(card.traits[selectedTrait].type)
        }
        
        // Now with an array of trait types of every card in the set of cards
        // convert that array to a mathematical set. If the set is equal to 1,
        // then all the traits were the same. If the set is equal to the number
        // of trait types, then all the traits were different.
        return Set(traitTypes).count == 1 || Set(traitTypes).count == traitTypes.count
    }
    
    struct CustomShapeCard: Identifiable, Equatable {
        var isPartOfSet = false.none
        var isSelected = false
        let traits: [CardContent]
        let id: Int
    }
}

extension Bool {
    var none: Int {
        return 0
    }
    var intValue: Int {
        return self ? 2 : 1
    }
}
