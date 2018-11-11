import XCTest
@testable import AudioFlashCards

class NumberFilterTest: XCTestCase {
    
    func test_getNumberFromTranscriptionText_ParsesIntegers() {
        let testNumber = Int.random(in: 0...20)
        let testObject = NumberFilter()
        
        let testNumberString = String(testNumber)
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText(testNumberString), testNumber)
    }
    
    func test_getNumberFromTranscriptionText_ConvertsNumberWords() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Zero"), 0)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("One"), 1)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Two"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Three"), 3)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Four"), 4)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Five"), 5)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Six"), 6)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Seven"), 7)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Eight"), 8)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Nine"), 9)
    }
    
    func test_getNumberFromTranscriptionText_ConvertsHomophones() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Won"), 1)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("To"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Too"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("For"), 4)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Or"), 4)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Ate"), 8)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Mine"), 9)
    }
    
    func test_getNumberFromTranscriptionText_WhenSentNonNumber_ThenReturnsMinusOne() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText(randomString()), -1)
    }
    
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let length = Int.random(in: 3...10)
        return String((0...length-1).map{ _ in letters.randomElement()! })
        
    }
}
