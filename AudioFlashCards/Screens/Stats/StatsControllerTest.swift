import XCTest
@testable import AudioFlashCards

class StatsControllerTest: XCTestCase {

    func test_OnInit_SetsViewToStatsView() {
        let view = StatsView()
        let testObject = StatsController(statsView: view,
                                         statsPresenter: StatsPresenter(statsModel: StatsModel(), statsView: StatsView()))
        
        XCTAssert(testObject.view === view)
    }

    
    func test_OnInit_SetsItselfToPresenterDelegate() {
        
        let presenter = StatsPresenter(statsModel: StatsModel(), statsView: StatsView())
        let testObject = StatsController(statsView:  StatsView(),
                                         statsPresenter: presenter)
        
        XCTAssert(presenter.delegate === testObject)
    }
    
    func test_WhenResetRequested_ThenDisplaysAlert() {
        let testObject = StatsController()
        UIApplication.shared.delegate!.window!!.rootViewController = testObject
        
        testObject.statsPresenterEvent_resetStatsRequested()
        
        let alertController = testObject.presentedViewController! as! UIAlertController
        XCTAssertTrue(alertController.isKind(of: UIAlertController.self))
        XCTAssertEqual(alertController.title, "Reset Statistics?")
        XCTAssertEqual(alertController.message, "Are you sure you would like to reset your statistics?")
        XCTAssertEqual(alertController.preferredStyle, UIAlertController.Style.alert)
        XCTAssertEqual(alertController.actions.count, 2)
        let alertAction0 = alertController.actions[0]
        XCTAssertEqual(alertAction0.title, "Yes")
        XCTAssertEqual(alertAction0.style, UIAlertAction.Style.cancel)
        let alertAction1 = alertController.actions[1]
        XCTAssertEqual(alertAction1.title, "No")
        XCTAssertEqual(alertAction1.style, UIAlertAction.Style.`default`)
    }
    
    func test_WhenCloseRequested_ThenCloses() {
        let cardController = CardController()
        UIApplication.shared.delegate!.window!!.rootViewController = cardController
        
        let exp = expectation(description: "Wait for test object to be dismissed")
        
        let testObject = StatsController()
        cardController.present(testObject, animated: true) {
            print("Complete block for present")
            exp.fulfill()
        }
        
        testObject.statsPresenterEvent_closeRequested()

        wait(for: [exp], timeout: 2.0)
    }
}
