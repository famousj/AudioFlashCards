import XCTest
@testable import AudioFlashCards

class CardModelTest: XCTestCase, CardModelDelegate {
    
    let emptyCardDeck = CardDeck(cards: [])
    
    func test_onInit_CreatesDeckFrom0to9() {
        let testObject = CardModel()
        
        let expectedDeck = CardDeck.additionDeck(min: 0, max: 9)
        XCTAssertEqual(Set(testObject.cardDeck.cards), Set(expectedDeck.cards))
    }
    
    func test_onInit_SetsItselfAsRecognizerDelegate() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer, numberFilter: NumberFilter())
        
        XCTAssertTrue(numberRecognizer.delegate === testObject)
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
                                   numberRecognizer: NumberRecognizerMock(),
                                   numberFilter: NumberFilter())
        
        XCTAssertNil(testObject.nextCard())
    }
    
    func test_ListenForAnswer_StartsNumberRecognizer() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer, numberFilter: NumberFilter())
        
        testObject.startListeningForAnswer()
        XCTAssertEqual(numberRecognizer.startListening_counter, 1)
    }
    
    func test_ListenForAnswer_WhenThrows_SendsErrorEvent() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer, numberFilter: NumberFilter())
        testObject.delegate = self
        
        let expectedError = NSError(domain: "PC-LOAD-LTR", code: Int.random(in: 42...4242), userInfo: nil)
        numberRecognizer.startListening_nextError = expectedError
        cardModelEvent_errorListeningForAnswer_counter = 0
        
        testObject.startListeningForAnswer()
        
        XCTAssertEqual(cardModelEvent_errorListeningForAnswer_paramError! as NSError, expectedError)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_CallsDelegateMethod() {
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: NumberFilter())
        testObject.delegate = self
        
        let testText = String(Int.random(in: 0...20))
        testObject.numberRecognizerEvent_textRecognized(text: testText)

        XCTAssertEqual(cardModelEvent_answerUpdated_counter, 1)
        XCTAssertTrue(cardModelEvent_answerUpdated_paramText == testText)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_CallsNumberFilter() {
        let numberFilter = NumberFilterMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
        
        let testText = String(Int.random(in: 0...20))
        testObject.numberRecognizerEvent_textRecognized(text: testText)
        
        XCTAssertEqual(numberFilter.getNumberFromTranscriptionText_counter, 1)
        XCTAssertTrue(numberFilter.getNumberFromTranscriptionText_paramText == testText)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_StopsListening() {
        let numberRecognizer = NumberRecognizerMock()
        let testObject = CardModel(cardDeck: emptyCardDeck, numberRecognizer: numberRecognizer, numberFilter: NumberFilter())
        
        let testText = String(Int.random(in: 0...20))
        testObject.numberRecognizerEvent_textRecognized(text: testText)
        
        XCTAssertEqual(numberRecognizer.stopListening_counter, 1)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_AndTextMatchesAnswer_TellsDelegateAnswerIsCorrect() {
        let numberFilter = NumberFilterMock()
        let testCard = Card.testInstance
        let cardDeck = CardDeck(cards: [testCard])
        
        let testObject = CardModel(cardDeck: cardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
        testObject.delegate = self
        
        let _ = testObject.nextCard()
        
        numberFilter.getNumberFromTranscriptionText_returnValue = testCard.answer
        testObject.numberRecognizerEvent_textRecognized(text: String("correct answer"))
        
        XCTAssertEqual(cardModelEvent_correctAnswerRecognized_counter, 1)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_AndTextDoesNotMatchAnswer_TellsDelegateAnswerIsWrong() {
        let numberFilter = NumberFilterMock()
        let testCard = Card.testInstance
        let cardDeck = CardDeck(cards: [testCard])
        
        let testObject = CardModel(cardDeck: cardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
        testObject.delegate = self
        
        let _ = testObject.nextCard()
        
        numberFilter.getNumberFromTranscriptionText_returnValue = testCard.answer + Int.random(in: 1...10)
        testObject.numberRecognizerEvent_textRecognized(text: String("totally wrong answer"))
        
        XCTAssertEqual(cardModelEvent_wrongAnswerRecognized_counter, 1)
    }
    
    func test_WhenReceiveListenerTextRecognizedEvent_AndNoCurrentCard_TellsDelegateAnswerIsCorrect() {
        let numberFilter = NumberFilterMock()
        let cardDeck = emptyCardDeck
        
        let testObject = CardModel(cardDeck: cardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
        testObject.delegate = self
        
        let _ = testObject.nextCard()
        
        testObject.numberRecognizerEvent_textRecognized(text: String("the right answer"))
        
        XCTAssertEqual(cardModelEvent_correctAnswerRecognized_counter, 0)
    }
    var cardModelEvent_errorListeningForAnswer_counter = 0
    var cardModelEvent_errorListeningForAnswer_paramError: Error?
    func cardModelEvent_errorListeningForAnswer(error: Error) {
        cardModelEvent_errorListeningForAnswer_counter += 1
        cardModelEvent_errorListeningForAnswer_paramError = error
    }
    
    var cardModelEvent_answerUpdated_counter = 0
    var cardModelEvent_answerUpdated_paramText: String?
    func cardModelEvent_textRecognized(text: String) {
        cardModelEvent_answerUpdated_counter += 1
        cardModelEvent_answerUpdated_paramText = text
    }
    
    var cardModelEvent_correctAnswerRecognized_counter = 0
    func cardModelEvent_correctAnswerRecognized() {
        cardModelEvent_correctAnswerRecognized_counter += 1
    }
    
    var cardModelEvent_wrongAnswerRecognized_counter = 0
    func cardModelEvent_wrongAnswerRecognized() {
        cardModelEvent_wrongAnswerRecognized_counter += 1
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
    
    var stopListening_counter = 0
    override func stopListening() {
        stopListening_counter += 1
    }
}

class NumberFilterMock: NumberFilter {
    var getNumberFromTranscriptionText_counter = 0
    var getNumberFromTranscriptionText_paramText: String?
    var getNumberFromTranscriptionText_returnValue = -1
    override func getNumberFromTranscriptionText(_ text: String) -> Int {
        getNumberFromTranscriptionText_counter += 1
        getNumberFromTranscriptionText_paramText = text
        return getNumberFromTranscriptionText_returnValue
    }
}
