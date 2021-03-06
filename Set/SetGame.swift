
import Foundation

struct SetGame<CardContent> where CardContent: Equatable & Traitable & Hashable {
    
    // Game definitions
    private(set) var isDone: Bool = false
    private let numberOfCardsInASet: Int
    private let deckSize: Int
    private let numberOfTraitTypes: Int
    private let numberOfTraits: Int
    
    // Card management
    private(set) var deck: [CustomShapeCard] = []
    private(set) var cardsInPlay: [CustomShapeCard] = []
    private(set) var setsMade: [[CustomShapeCard]] = []
    private(set) var selectedCards: [CustomShapeCard] = []
    
    // Scoring
    private(set) var prevDate: Date = Date()
    private(set) var score: Int = 0
    private(set) var scoreModifier: Int = 0
    private(set) var antiCheat: Bool = false
    private(set) var highScore: Int = 0
    
    // Two-player scoring
    private(set) var isMultiplayer: Bool = false
    private(set) var turnPlayerTwo: Bool = false
    private(set) var scorePlayerTwo: Int = 0
    
    // Cheat
    private(set) var cheatVision: Bool = false
    
    // Utility
    private(set) var result: [CardContent] = []
    private(set) var setIndices: [Int] = []
    private(set) var cheatIndices: [Int] = []
    private(set) var id: Int = 0
    
    init(numberOfTraits: Int, numberOfTraitTypes: Int, withSetsOf numberOfCardsInASet: Int) {
        self.numberOfTraits = numberOfTraits
        self.numberOfTraitTypes = numberOfTraitTypes
        self.deckSize = Int(pow(Double(numberOfTraitTypes), Double(numberOfTraits)))
        self.numberOfCardsInASet = numberOfCardsInASet
        for _ in 0..<numberOfCardsInASet {
            setIndices.append(0)
        }
        startNewGame()
    }

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
    
    mutating func clearSelectedSet() {
        var discardedSet: [CustomShapeCard] = []
        if !selectedCards.isEmpty && selectedCards[0].isPartOfSet == true.intValue {
            for c in selectedCards {
                discardedSet.append(cardsInPlay.remove(at: cardsInPlay.firstIndex(of: c)!))
            }
            selectedCards = []
            setsMade.append(discardedSet)
        }
        print(setsMade.count)
    }
    
    // Deals 1 card from the deck.
    mutating func deal(wasPressed: Bool = false) -> Bool {
        if setIsAvailable() && wasPressed &&
            cardsInPlay.count >= numberOfCardsInASet {
            scoreModifier = 0
        }
        
        if deck.count > 0 {
            // Deal card
            cardsInPlay.append(deck.removeFirst())
        } else {
            return false
        }
        
        return true
    }
    
    func setIsAvailable() -> Bool {
        Set(cheatIndices).count == cheatIndices.count
    }
    
    mutating func turnToPlayerOne() {
        turnPlayerTwo = false
    }
    
    mutating func turnToPlayerTwo() {
        turnPlayerTwo = true
    }
    
    mutating func toggleMultiplayer() {
        isMultiplayer.toggle()
    }
    
    mutating func toggleCheatVision() {
        cheatVision.toggle()
    }
    
    func setFromIndices(with indices: [Int]) -> [CustomShapeCard] {
        var theSet: [CustomShapeCard] = []
        for index in indices {
            theSet.append(cardsInPlay[index])
        }
        return theSet
    }
    
    mutating func lookForSet(cardIndex: Int) -> Bool {
        if setIndices[cardIndex] < cardsInPlay.count {
            if cardIndex < numberOfCardsInASet - 1 {
                for _ in 0..<cardsInPlay.count {
                    if lookForSet(cardIndex: cardIndex + 1) {
                        return true
                    }
                    setIndices[cardIndex] += 1
                    cheatIndices = setIndices
                }
            } else {
                if Set(setIndices).count == setIndices.count
                    && isSet(setFromIndices(with: setIndices)) {
                    return true
                } else {
                    setIndices[cardIndex] += 1
                    cheatIndices = setIndices
                    if lookForSet(cardIndex: cardIndex) {
                        return true
                    }
                }
            }
        } else {
            setIndices[cardIndex] = 0
            cheatIndices = setIndices
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

    mutating func startNewGame() {
        deck = []
        cardsInPlay = []
        setsMade = []
        selectedCards = []
        
        result = []
        resetIndices()
        
        createDeck(currentTrait: 0)
        //deck.shuffle()
        
        score = 0
        scoreModifier = 0
        antiCheat = false
        prevDate = Date()
        
        resetIndices()
        print(lookForSet(cardIndex: 0))
        cheatIndices = setIndices
        checkIfDone()
        
        cheatVision = false

        isDone = false
    }
    
    mutating func checkIfDone() {
        if  deck.isEmpty && (selectedCards.count == cardsInPlay.count ||
                             cardsInPlay.count < numberOfCardsInASet ||
                             !lookForSet(cardIndex: 0)) {
            cardsInPlay = []
            isDone = true
        }
    }
    
    mutating func choose(_ card: CustomShapeCard) {
        if let chosenIndex = cardsInPlay.firstIndex(of: card),
           cardsInPlay[chosenIndex].isPartOfSet != true.intValue {
            // Set is selected
            if selectedCards.count >= numberOfCardsInASet {
                if !cheatVision {
                    scoreModifier += calculateScoreModifier()
                }
                if selectedCards[0].isPartOfSet == true.intValue {
                    chooseWithSetSelected(card, chosenIndex)
                } else {
                    chooseWithMismatchSelected(card, chosenIndex)
                }
            // Set is not selected
            } else {
                if selectedCards.contains(cardsInPlay[chosenIndex]) {
                    deselectCard(card, chosenIndex)
                } else {
                    if !cheatVision {
                        scoreModifier += calculateScoreModifier()
                    }
                    cardsInPlay[chosenIndex].isSelected = true
                    selectedCards.append(cardsInPlay[chosenIndex])
                    if selectedCards.count >= numberOfCardsInASet {
                        evaluateSetSelection(card, chosenIndex)
                    }
                }
            }
        }
    }
    
    mutating func chooseWithSetSelected(_ card: CustomShapeCard, _ chosenIndex: Int) {
        cardsInPlay[chosenIndex].isSelected = true
        // Choose new card, discard set
        let chosen = cardsInPlay[chosenIndex]
        clearSelectedSet()
        selectedCards.append(chosen)
        resetIndices()
        print(lookForSet(cardIndex: 0))
        checkIfDone()
    }
    
    mutating func chooseWithMismatchSelected(_ card: CustomShapeCard, _ chosenIndex: Int) {
        for c in selectedCards {
            let i = cardsInPlay.firstIndex(of: c)!
            cardsInPlay[i].isSelected = false
            cardsInPlay[i].isPartOfSet = false.none
        }
        selectedCards = []
        cardsInPlay[chosenIndex].isSelected = true
        selectedCards.append(cardsInPlay[chosenIndex])
        scoreModifier = 0
    }
    
    mutating func deselectCard(_ card: CustomShapeCard, _ chosenIndex: Int) {
        antiCheat = true
        let i = selectedCards.firstIndex(of: cardsInPlay[chosenIndex])!
        cardsInPlay[chosenIndex].isSelected = false
        selectedCards.remove(at: i)
    }
    
    mutating func evaluateSetSelection(_ card: CustomShapeCard, _ chosenIndex: Int) {
        if isSet(selectedCards) {
            for (i, c) in selectedCards.enumerated() {
                cardsInPlay[cardsInPlay.firstIndex(of: c)!].isPartOfSet = true.intValue
                selectedCards[i].isPartOfSet = true.intValue
            }
            
            if !cheatVision {
                if isMultiplayer {
                    if turnPlayerTwo {
                        scorePlayerTwo += scoreModifier * 5
                    } else {
                        score += scoreModifier * 5
                    }
                } else {
                    score += scoreModifier * 5
                }
                
                if score > highScore {
                    highScore = score
                } else if scorePlayerTwo > score {
                    highScore = scorePlayerTwo
                }
            }
            
            checkIfDone()
        } else {
            for (i, c) in selectedCards.enumerated() {
                cardsInPlay[cardsInPlay.firstIndex(of: c)!].isPartOfSet = false.intValue
                selectedCards[i].isPartOfSet = false.intValue
            }
        }
    }
    
    private func isSet(_ setOfCards: [CustomShapeCard]) -> Bool {
        if  setOfCards.count > numberOfCardsInASet ||
            setOfCards.count < numberOfCardsInASet ||
            Set(setOfCards).count < setOfCards.count {
            return false
        }
        let traits = setOfCards[0].traits
        
        // For every trait T that exists in the game,
        // check if T in the first card has the same or different type
        // as the type of T in every other card.
        for (traitIndex, _) in traits.enumerated() {
            if !traitAllSameOrAllDifferentType(setOfCards, with: traitIndex) {
                return false
            }
        }

        return true
    }
    
    // Returns true if an array of cards all have the same or different type of the selected trait.
    private func traitAllSameOrAllDifferentType(_ setOfCards: [CustomShapeCard], with selectedTrait: Int) -> Bool {
        if setOfCards.count != numberOfCardsInASet {
            return false
        }
        
        // Go through the set of cards given. For every card, take the selected trait's type
        // and append it to the temporary array of trait types.
        var traitTypes: [Int] = []
        for card in setOfCards {
            traitTypes.append(card.traits[selectedTrait].type)
        }
        
        // Now with an array of trait types of every card from the given set,
        // convert that array to a mathematical set. If the set is equal to 1,
        // then all the traits were the same. If the set is equal to the number
        // of trait types, then all the traits were different. If neither,
        // then the trait types were not all the same or all different.
        return Set(traitTypes).count == 1 || Set(traitTypes).count == traitTypes.count
    }
    
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
