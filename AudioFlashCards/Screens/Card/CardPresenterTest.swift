import XCTest
@testable import AudioFlashCards

class CardPresenterTest: XCTestCase, CardPresenterDelegate {
    
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
        XCTAssertEqual(view.renderAnswerShown_paramIsShown, true)
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
    
    var cardPresenterEvent_errorListeningForAnswer_counter = 0
    var cardPresenterEvent_errorListeningForAnswer_paramError: Error?
    func cardPresenterEvent_errorListeningForAnswer(error: Error) {
        cardPresenterEvent_errorListeningForAnswer_counter += 1
        cardPresenterEvent_errorListeningForAnswer_paramError = error
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
    var renderAnswerShown_paramIsShown: Bool?
    override func renderAnswerShown(_ isShown: Bool) {
        renderAnswerShown_counter += 1
        renderAnswerShown_paramIsShown = isShown
    }
}

