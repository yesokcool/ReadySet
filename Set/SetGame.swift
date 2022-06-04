
import Foundation

struct SetGame<CardContent> where CardContent: Equatable & Traitable & Hashable {
    private(set) var deck: [CustomShapeCard] = []
    private(set) var fixedDeck: [CustomShapeCard] = []
    private(set) var cardsInPlay: [CustomShapeCard] = []
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private(set) var result: [CardContent] = []
    private(set) var setIndices: [Int] = []
    private(set) var cheatIndices: [Int] = []
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    private(set) var setsMade: [[CustomShapeCard]] = []
    private(set) var selectedCards: [CustomShapeCard] = []
    private(set) var id: Int = 0
    private(set) var gameComplete: Bool = false
    private(set) var prevDate: Date = Date()
    private(set) var score: Int = 0
    private(set) var scoreModifier: Int = 0
    private(set) var antiCheat: Bool = false
    private(set) var highScore: Int = 0
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, setsOf numberOfCardsInASet: Int) {
        self.numberOfTraits = numberOfTraits
        self.numberOfTraitTypes = numberOfTraitTypes
        self.deckSize = Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits)))
        self.numberOfCardsInASet = numberOfCardsInASet
        for _ in 0..<numberOfCardsInASet {
            setIndices.append(0)
        }
        newGame()
    }
    
    // TODO: Void function just returning? Good style?
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
    
    
    mutating func resetIndices() {
        for i in 0..<numberOfCardsInASet {
            setIndices[i] = 0
        }
    }
    
    // TODO: Perhaps could be deal any the game wants to.
    
    // Deals 3 cards from the shuffled deck.
    mutating func dealThree() -> Bool {
        for _ in 0..<3 {
            if deck.count > 0 {
                // Discard cards in a set
                if (!selectedCards.isEmpty && selectedCards[0].isPartOfSet == true.intValue) {
                    for c in selectedCards {
                        cardsInPlay.remove(at: cardsInPlay.firstIndex(of: c)!)
                    }
                    selectedCards = []
                }
                // Deal card
                cardsInPlay.append(deck.removeFirst())
            }
            else {
                return false
            }
        }
        return true
    }
    
    mutating func shuffle() {
        
    }
    
    func setFromIndices(with indices: [Int]) -> [CustomShapeCard] {
        var theSet: [CustomShapeCard] = []
        for index in indices {
            theSet.append(cardsInPlay[index])
        }
        return theSet
    }
    
    mutating func checkIfSetIsAvailable(cardIndex: Int) -> Bool {
        print("\(setIndices)")
        print("\(cardsInPlay.count)")
        if setIndices[cardIndex] < cardsInPlay.count {
            print("Loop 1")
            if cardIndex < numberOfCardsInASet - 1 {
                for _ in 0..<cardsInPlay.count {
                    if (checkIfSetIsAvailable(cardIndex: cardIndex + 1)) {
                        return true
                    }
                    setIndices[cardIndex] += 1
                    print("Loop 7")
                }
            }
            else {
                print("Loop 2")
                if (Set(setIndices).count == setIndices.count
                    && isSet(setFromIndices(with: setIndices))) {
                    print("Loop3")
                    return true
                }
                else {
                    print("Loop 4")
                    setIndices[cardIndex] += 1
                    if (checkIfSetIsAvailable(cardIndex: cardIndex)) {
                        return true
                    }
                }
            }
        }
        else {
            print("Loop 8")
            print("\(setIndices)")
            setIndices[cardIndex] = 0
        }
        
        return false
    }
    
    mutating func calculateScoreModifier() -> Int {
        if antiCheat {
            antiCheat.toggle()
            return 0
        }

        let modifier = Int(pow(Double(max(10 - (-Int(prevDate.timeIntervalSinceNow)), 1)), 2.0))
        prevDate = Date()
        
        return modifier
    }
    
    // TODO: Set it back to shuffle when done debugging.
    mutating func newGame() {
        deck = []
        cardsInPlay = []
        setsMade = []
        selectedCards = []
        
        result = []
        resetIndices()
        
        createDeck(currentTrait: 0)
        deck.shuffle()
        // debug deck.removeSubrange(3..<deck.count)
        fixedDeck = deck
        
        score = 0
        scoreModifier = 0
        antiCheat = false
        prevDate = Date()
        
        startingDeal()
        
        resetIndices()
        print(checkIfSetIsAvailable(cardIndex: 0))
        cheatIndices = setIndices
        checkIfGameIsCompleted()
        
        // debug to clear out cards faster
        /*
        for _ in 1...20 {
            choose(cardsInPlay[0])
            choose(cardsInPlay[1])
            choose(cardsInPlay[2])
            choose(cardsInPlay[3])
            choose(cardsInPlay[0])
        }*/

        gameComplete = false
    }
    
    mutating func startingDeal() {
        for _ in 1...4 {
            _ = dealThree()
        }
    }
    
    mutating func checkIfGameIsCompleted() {
        if (deck.isEmpty &&
            (selectedCards.count == cardsInPlay.count ||
             cardsInPlay.count < numberOfCardsInASet ||
            !checkIfSetIsAvailable(cardIndex: 0))) {
            cardsInPlay = []
            gameComplete = true
            print("GAME COMPLETE!!")
        }
    }
    
    // TODO: Currently using both isSelected and selectedCards.
    // Perhaps possible to just need to use one of these
    // TODO: Maybe make extension more readable and replace intValue
    // for something else.
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = cardsInPlay.firstIndex(of: card),
           cardsInPlay[chosenIndex].isPartOfSet != true.intValue {
            // Set is selected
            if selectedCards.count >= numberOfCardsInASet {
                scoreModifier += calculateScoreModifier()
                // Set selected is an actual set
                if selectedCards[0].isPartOfSet == true.intValue {
                    cardsInPlay[chosenIndex].isSelected = true
                    // Choose new card, discard set
                    let chosen = cardsInPlay[chosenIndex]
                    for c in selectedCards {
                        cardsInPlay.remove(at: cardsInPlay.firstIndex(of: c)!)
                    }
                    selectedCards = []
                    selectedCards.append(chosen)
                    _ = dealThree()
                    resetIndices()
                    print(checkIfSetIsAvailable(cardIndex: 0))
                    cheatIndices = setIndices
                    checkIfGameIsCompleted()
                }
                // Set selected is not an actual set
                else {
                    for c in selectedCards {
                        let i = cardsInPlay.firstIndex(of: c)!
                        cardsInPlay[i].isSelected = false
                        cardsInPlay[i].isPartOfSet = false.none
                    }
                    selectedCards = []
                    cardsInPlay[chosenIndex].isSelected = true
                    selectedCards.append(cardsInPlay[chosenIndex])
                    scoreModifier = 1
                }
            }
            // Set is not selected
            else {
                // Deselection
                if (selectedCards.contains(cardsInPlay[chosenIndex])) {
                    antiCheat = true
                    let i = selectedCards.firstIndex(of: cardsInPlay[chosenIndex])!
                    cardsInPlay[chosenIndex].isSelected = false
                    selectedCards.remove(at: i)
                }
                // Selection
                else {
                    scoreModifier += calculateScoreModifier()
                    print("Choosing \(card)!")
                    cardsInPlay[chosenIndex].isSelected = true
                    selectedCards.append(cardsInPlay[chosenIndex])
                    if selectedCards.count >= numberOfCardsInASet {
                        if isSet(selectedCards) {
                            // Set is a set
                            print("IS A SET!")
                            setsMade.append(selectedCards)
                            for (i, c) in selectedCards.enumerated() {
                                cardsInPlay[cardsInPlay.firstIndex(of: c)!].isPartOfSet = true.intValue
                                selectedCards[i].isPartOfSet = true.intValue
                            }
                            score += scoreModifier * 5
                            if score > highScore {
                                highScore = score
                            }
                            // Last set made and game complete
                            checkIfGameIsCompleted()
                        }
                        // Set is not a set
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
    
    private func isSet(_ setOfCards: [CustomShapeCard]) -> Bool {
        if setOfCards.count > numberOfCardsInASet
            || setOfCards.count < numberOfCardsInASet || Set(setOfCards).count < setOfCards.count {
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

        return true
    }
    
    // Check if an array of cards all have the same or different selected trait, or not.
    private func traitAllSameOrAllDifferentType(_ setOfCards: [CustomShapeCard], with selectedTrait: Int) -> Bool {
        if setOfCards.count != numberOfCardsInASet {
            return false
        }
        
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
    
    // TODO: If there are cards left but no sets possible, how to handle?
    // Just to check the game for any possible sets seems expensive.
    // But if you could check it and there were not sets, it would be
    // the same result as game being completed.
    
    struct CustomShapeCard: Identifiable, Equatable, Hashable {
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
