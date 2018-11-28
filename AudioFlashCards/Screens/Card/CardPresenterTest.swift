import XCTest
@testable import AudioFlashCards

class CardPresenterTest: XCTestCase, CardPresenterDelegate {
    
    override func setUp() {
        super.setUp()
        cardPresenterEvent_presentStatistics_counter = 0
        cardPresenterEvent_errorListeningForAnswer_counter = 0
    }
    
    func test_OnInit_SetsItselfToViewDelegate() {
        let view = CardView()
        let testObject = CardPresenter(cardModel: CardModel(), view: view)
        
        XCTAssertTrue(view.delegate! === testObject)
    }
    
    func test_OnInit_SetsItselfToModelDelegate() {
        let model = CardModel()
        let testObject = CardPresenter(cardModel: model, view: CardView())
        
        XCTAssertTrue(model.delegate! === testObject)
    }
    
    func test_WhenViewGesturedToRevealAnswer_ThenAskViewToRevealAnswer() {
        let view = CardViewMock()
        let testObject = CardPresenter(cardModel: CardModelMock(), view: view)
        
        testObject.cardViewEvent_gesturedRevealAnswer()
        XCTAssertEqual(view.renderAnswerShown_counter, 1)
        XCTAssertEqual(view.renderAnswerShown_paramAnswerIsCorrect, false)
    }
    
    func test_WhenViewGesturedDoneWithCard_ThenRenderViewWithNextCard() {
        let view = CardViewMock()
        let model = CardModelMock()
        
        let testObject = CardPresenter(cardModel: model, view: view)

        view.renderCard_counter = 0
        let card = Card.testInstance
        model.nextCard_nextReturnValue = card

        testObject.cardViewEvent_gesturedDoneWithCard()
        
        XCTAssertEqual(view.renderCard_counter, 1)
        XCTAssertEqual(view.renderCard_paramCard, card)
    }
    
    func test_WhenViewGesturedDoneWithCard_ThenRenderViewWithInstructionsHidden() {
        let view = CardViewMock()
        
        let testObject = CardPresenter(cardModel: CardModelMock(), view: view)
                
        testObject.cardViewEvent_gesturedDoneWithCard()
        
        XCTAssertEqual(view.renderInstructionsHidden_counter, 1)
        XCTAssertEqual(view.renderInstructionsHidden_paramIsHidden, true)
    }

    
    func test_WhenViewGesturedDoneWithCard_AndNextCardIsNil_ThenDoNotRenderView() {
        let view = CardViewMock()
        let model = CardModelMock()
        
        let testObject = CardPresenter(cardModel: model, view: view)
        
        view.renderCard_counter = 0
        model.nextCard_nextReturnValue = nil
        testObject.cardViewEvent_gesturedDoneWithCard()
        
        XCTAssertEqual(view.renderCard_counter, 0)
    }
    
    func test_WhenCardModelHasErrorListening_ThenInformsDelegate() {
        let testObject = CardPresenter(cardModel: CardModel(), view: CardView())
        testObject.delegate = self
        
        let testError = NSError(domain: "Another error", code: Int.random(in: 10...20), userInfo: nil)
        testObject.cardModelEvent_errorListeningForAnswer(error: testError)
        
        XCTAssertEqual(cardPresenterEvent_errorListeningForAnswer_paramError! as NSError, testError)
    }
    
    func test_WhenModelReceivesAnswerText_ThenUpdatesView() {
        let view = CardViewMock()
        let testObject = CardPresenter(cardModel: CardModelMock(), view: view)
        
        let testText = String(Int.random(in: 10...100))
        testObject.cardModelEvent_textRecognized(text: testText)
        
        XCTAssertEqual(view.renderRecognitionText_counter, 1)
        XCTAssertTrue(view.renderRecognitionText_paramText == testText)
    }
    
    func test_WhenModelReceivesCorrectAnswer_ThenTellsViewToRevealAnswer() {
        let view = CardViewMock()
        let testObject = CardPresenter(cardModel: CardModelMock(), view: view)
        
        testObject.cardModelEvent_correctAnswerRecognized()
        
        XCTAssertEqual(view.renderAnswerShown_counter, 1)
        XCTAssertEqual(view.renderAnswerShown_paramAnswerIsCorrect, true)
    }
    
    func test_WhenModelReceivesWrongAnswer_ThenTellsViewToRevealAnswerAsIncorrect() {
        let view = CardViewMock()
        let testObject = CardPresenter(cardModel: CardModelMock(), view: view)
        
        testObject.cardModelEvent_wrongAnswerRecognized()
        
        XCTAssertEqual(view.renderAnswerShown_counter, 1)
        XCTAssertEqual(view.renderAnswerShown_paramAnswerIsCorrect, false)
    }
    
    func test_WhenViewGesturedToShowStatistics_CallDelegate() {
        let testObject = CardPresenter(cardModel: CardModelMock(), view: CardViewMock())
        testObject.delegate = self
        
        testObject.cardViewEvent_gesturedViewStatistics()
        
        XCTAssertEqual(cardPresenterEvent_presentStatistics_counter, 1)
    }
    
    var cardPresenterEvent_errorListeningForAnswer_counter = 0
    var cardPresenterEvent_errorListeningForAnswer_paramError: Error?
    func cardPresenterEvent_errorListeningForAnswer(error: Error) {
        cardPresenterEvent_errorListeningForAnswer_counter += 1
        cardPresenterEvent_errorListeningForAnswer_paramError = error
    }

    var cardPresenterEvent_presentStatistics_counter = 0
    func cardPresenterEvent_presentStatistics() {
        cardPresenterEvent_presentStatistics_counter += 1
    }
}

class CardModelMock: CardModel {
    var nextCard_counter = 0
    var nextCard_nextReturnValue: Card?
    override func nextCard() -> Card? {
        nextCard_counter += 1
        return nextCard_nextReturnValue
    }
}

class CardViewMock: CardView {
    var renderCard_counter = 0
    var renderCard_paramCard: Card?
    override func renderCard(_ card: Card) {
        renderCard_counter += 1
        renderCard_paramCard = card
    }
    
    var renderAnswerShown_counter = 0
    var renderAnswerShown_paramAnswerIsCorrect: Bool?
    override func renderAnswerShown(answerIsCorrect: Bool) {
        renderAnswerShown_counter += 1
        renderAnswerShown_paramAnswerIsCorrect = answerIsCorrect
    }
    
    var renderRecognitionText_counter = 0
    var renderRecognitionText_paramText: String?
    override func renderRecognitionText(text: String) {
        renderRecognitionText_counter += 1
        renderRecognitionText_paramText = text
    }
    
    var renderInstructionsHidden_counter = 0
    var renderInstructionsHidden_paramIsHidden: Bool?
    override func renderInstructionsHidden(isHidden: Bool) {
        renderInstructionsHidden_counter += 1
        renderInstructionsHidden_paramIsHidden = isHidden
    }
}

