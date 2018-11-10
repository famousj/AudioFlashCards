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
        model.nextCard_nextReturnValue = testCard
        
        let view = CardViewMock()
        
        let _ = CardPresenter(cardModel: model, view: view)
        XCTAssertEqual(model.nextCard_counter, 1)
        XCTAssertEqual(view.renderCard_counter, 1)
        XCTAssertEqual(view.renderCard_paramCard, testCard)
    }
}

class CardModelMock: CardModel {
    var nextCard_counter = 0
    var nextCard_nextReturnValue: Card?
    override func nextCard() -> Card {
        nextCard_counter += 1
        return nextCard_nextReturnValue!
    }
}

class CardViewMock: CardView {
    var renderCard_counter = 0
    var renderCard_paramCard: Card?
    override func renderCard(_ card: Card) {
        renderCard_counter += 1
        renderCard_paramCard = card
    }
}

