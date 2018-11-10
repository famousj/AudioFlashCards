import XCTest
@testable import AudioFlashCards

class CardModelTest: XCTestCase {

    func test_nextCard_returnsGenericCard() {
        let testObject = CardModel()
        
        let expectedCard = Card(num1: 6, num2: 8, operation: "+", answer: 14)
        
        XCTAssertEqual(expectedCard, testObject.nextCard())
    }
}
