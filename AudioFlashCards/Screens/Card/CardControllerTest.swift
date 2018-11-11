import XCTest
@testable import AudioFlashCards

class CardControllerTest: XCTestCase {

    func test_OnInit_SetsItselfAsPresenterDelegate() {
        let view = CardView()
        let model = CardModelMock()
        let presenter  = CardPresenter(cardModel: model, view: view)
        
        let testObject = CardController(cardView: view, cardPresenter: presenter)
        
        XCTAssertTrue(presenter.delegate === testObject)
    }
    
    func test_OnViewDidAppear_RequestsNextCard() {
        let model = CardModelMock()
        let view = CardViewMock()
        let presenter = CardPresenterMock(cardModel: model, view: view)
        let testObject = CardController(cardView: view, cardPresenter: presenter)
        
        testObject.viewDidAppear(true)
        
        XCTAssertEqual(presenter.showNextCard_counter, 1)
    }
    
    func test_OnPresenterErrorListeningEvent_DisplaysAlertController() {
        let testObject = CardController()
        UIApplication.shared.delegate!.window!!.rootViewController = testObject

        let expectedError = NSError(domain: "test domain", code: Int.random(in: 17...24), userInfo: nil)
        testObject.cardPresenterEvent_errorListeningForAnswer(error: expectedError)
        
        let alertController = testObject.presentedViewController! as! UIAlertController
        XCTAssertTrue(alertController.isKind(of: UIAlertController.self))
        XCTAssertEqual(alertController.title, "Error Listening")
        XCTAssertEqual(alertController.message, expectedError.localizedDescription)
        XCTAssertEqual(alertController.preferredStyle, UIAlertController.Style.alert)
        XCTAssertEqual(alertController.actions.count, 1)
        let alertAction = alertController.actions[0]
        XCTAssertEqual(alertAction.title, "Ok")
        XCTAssertEqual(alertAction.style, UIAlertAction.Style.cancel)
    }
}

class CardPresenterMock: CardPresenter {
    var showNextCard_counter = 0
    override func showNextCard() {
        showNextCard_counter += 1
    }
}
