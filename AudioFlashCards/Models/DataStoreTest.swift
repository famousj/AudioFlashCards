import XCTest
@testable import AudioFlashCards

class DataStoreTest: XCTestCase {
    
    func test_OnInit_setsValuesToZero() {
        let testObject = DataStore()
        
        XCTAssertEqual(testObject.cardsCorrect, 0)
        XCTAssertEqual(testObject.cardsIncorrect, 0)
        XCTAssertEqual(testObject.avgResponseTime, 0)
    }

    func test_resetStatistics_setsValuesToZero() {
        let testObject = DataStore()
        testObject.cardsCorrect = Int.random(in: 100...1000)
        testObject.cardsIncorrect = Int.random(in: 2000...5000)
        testObject.avgResponseTime = Double.random(in: 1...20)
        
        testObject.resetStatistics()
        
        XCTAssertEqual(testObject.cardsCorrect, 0)
        XCTAssertEqual(testObject.cardsIncorrect, 0)
        XCTAssertEqual(testObject.avgResponseTime, 0)
    }
}

class DataStoreMock: DataStore {
    
    var resetStatistics_counter = 0
    override func resetStatistics() {
        resetStatistics_counter += 1
    }
}
