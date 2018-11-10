import XCTest
@testable import AudioFlashCards

class CardDeckTest: XCTestCase {
    
    func test_dropFirstCard_createsNewDeckMinusTopCard() {
        let cards = [Card.testInstance, Card.testInstance, Card.testInstance]
        let deck = CardDeck(cards: cards)
        
        let newDeck = deck.dropFirstCard()
        XCTAssertEqual(newDeck.cards, Array(cards.dropFirst()))
    }
    
    func test_dropFirstCard_ifDeckIsEmpty_returnsEmptyDeck() {
        let deck = CardDeck(cards: [])
        
        let newDeck = deck.dropFirstCard()
        XCTAssertEqual(newDeck.cards, [])
    }

    func test_additionDeck_createsAdditionCards_randomized() {
        let min = Int.random(in: 0...10)
        let max = Int.random(in: 11...20)

        var expectedCards: [Card] = []
        for i in (min...max) {
            for j in (min...max) {
                expectedCards.append(Card.AdditionCard(num1: i, num2: j))
            }
        }
        
        let testObject = CardDeck.additionDeck(min: min, max: max)
        XCTAssertNotEqual(testObject.cards, expectedCards)
        XCTAssertEqual(Set(testObject.cards), Set(expectedCards))
    }
}
