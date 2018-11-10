import XCTest
@testable import AudioFlashCards

class CardPresenterTest: XCTestCase {
    
    func test_OnInit_SetsItselfToViewDelegate() {
        let view = CardView()
        let testObject = CardPresenter(cardModel: CardModel(), view: view)
        
        XCTAssertTrue(view.delegate! === testObject)
    }

    func test_OnInit_SendsModelNextCardToView() {
        let model = CardModelMock()
        let testCard = Card.testInstance
        model.nextCard_nextReturnValues = [testCard]
        
        let view = CardViewMock()
        
        let _ = CardPresenter(cardModel: model, view: view)
        XCTAssertEqual(model.nextCard_counter, 1)
        XCTAssertEqual(view.renderCard_counter, 1)
        XCTAssertEqual(view.renderCard_paramCard, testCard)
    }
    
    func test_WhenViewGesturedToRevealAnswer_ThenAskViewToRevealAnswer() {
        let view = CardViewMock()
        let testObject = CardPresenter(cardModel: CardModel(), view: view)
        
        testObject.cardViewEvent_gesturedRevealAnswer()
        XCTAssertEqual(view.renderAnswerShown_counter, 1)
        XCTAssertEqual(view.renderAnswerShown_paramIsShown, true)
    }
    
    func test_WhenViewGesturedDoneWithCard_ThenRenderViewWithNextCard() {
        let view = CardViewMock()
        let model = CardModelMock()
        let firstCard = Card.testInstance
        let secondCard = Card.testInstance
        model.nextCard_nextReturnValues = [firstCard, secondCard]
        
        let testObject = CardPresenter(cardModel: model, view: view)

        testObject.cardViewEvent_gesturedDoneWithCard()
        
        XCTAssertEqual(view.renderCard_counter, 2)
        XCTAssertEqual(view.renderCard_paramCard, secondCard)
    }
}

class CardModelMock: CardModel {
    var nextCard_counter = 0
    var nextCard_nextReturnValues: [Card] = []
    override func nextCard() -> Card {
        nextCard_counter += 1
        return nextCard_nextReturnValues.removeFirst()
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

