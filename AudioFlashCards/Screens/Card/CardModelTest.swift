import XCTest
@testable import AudioFlashCards

class CardModelTest: XCTestCase {
    
    func test_onInit_createsDeckFrom0to9() {
        let testObject = CardModel()
        
        let expectedDeck = CardDeck.additionDeck(min: 0, max: 9)
        XCTAssertEqual(Set(testObject.cardDeck.cards), Set(expectedDeck.cards))
    }

    func test_nextCard_returnsTopCardInDeck() {
        let testObject = CardModel()
        
        let cards = testObject.cardDeck.cards
        
        cards.forEach { (card) in
            XCTAssertEqual(testObject.nextCard(), card)
        }
    }
    
    func test_nextCard_whenDeckIsEmpty_returnsNil() {
        let testObject = CardModel(cardDeck: CardDeck(cards: []))
        
        let cards = testObject.cardDeck.cards
        
        cards.forEach { (card) in
            XCTAssertEqual(testObject.nextCard(), card)
        }
    }
}
