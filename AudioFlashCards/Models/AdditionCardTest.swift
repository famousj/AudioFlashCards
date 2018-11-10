import XCTest
import UIKit
@testable import AudioFlashCards

class AdditionCardTest: XCTestCase {

    func test_additionCard_worksCorrectly() {
        
        let num1 = Int.random(in: 0...12)
        let num2 = Int.random(in: 0...12)
        let sum = num1 + num2
        
        let expectedCard = Card(num1: num1, num2: num2, operation: "+", answer: sum)
        let actualCard = Card.AdditionCard(num1: num1, num2: num2)
        XCTAssertEqual(expectedCard, actualCard)
    }
}
