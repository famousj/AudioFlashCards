import XCTest
@testable import AudioFlashCards

class CardModelTest: XCTestCase, CardModelDelegate {
    
    let emptyCardDeck = CardDeck(cards: [])
    
    func test_onInit_createsDeckFrom0to9() {
        let testObject = CardModel()
        
        let expectedDeck = CardDeck.additionDeck(min: 0, max: 9)
        XCTAssertEqual(Set(testObject.cardDeck.cards), Set(expectedDeck.cards))
    }
    
    func test_NextCard_ReturnsTopCardInDeck() {
        let testObject = CardModel()
        
        let cards = testObject.cardDeck.cards
        
        cards.forEach { (card) in
            XCTAssertEqual(testObject.nextCard(), card)
        }
    }
    
    func test_NextCard_WhenDeckIsEmpty_ReturnsNil() {
        let testObject = CardModel(cardDeck: emptyCardDeck,
                                   numberRecognizer: NumberRecognizerMock())
        
        XCTAssertNil(testObject.nextCard())
    }
    
    func test_ListenForAnswer_StartsNumberRecognizer() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer)
        
        testObject.startListeningForAnswer()
        XCTAssertEqual(numberRecognizer.startListening_counter, 1)
    }
    
    func test_ListenForAnswer_WhenThrows_SendsErrorEvent() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer)
        testObject.delegate = self
        
        let expectedError = NSError(domain: "PC-LOAD-LTR", code: Int.random(in: 42...4242), userInfo: nil)
        numberRecognizer.startListening_nextError = expectedError
        cardModelEvent_errorListeningForAnswer_counter = 0
        
        testObject.startListeningForAnswer()
        
        XCTAssertEqual(cardModelEvent_errorListeningForAnswer_paramError! as NSError, expectedError)
    }

    var cardModelEvent_errorListeningForAnswer_counter = 0
    var cardModelEvent_errorListeningForAnswer_paramError: Error?
    func cardModelEvent_errorListeningForAnswer(error: Error) {
        cardModelEvent_errorListeningForAnswer_counter += 1
        cardModelEvent_errorListeningForAnswer_paramError = error
    }
}

class NumberRecognizerMock: NumberRecognizer {
    var startListening_counter = 0
    var startListening_nextError: Error?
    override func startListening() throws {
        startListening_counter += 1
        if let error = startListening_nextError {
            throw error
        }
    }
}
