import XCTest
@testable import AudioFlashCards

class DataStoreTest: XCTestCase {
    
    func test_OnInit_setsValuesToDefaults() {
        let testObject = DataStore()
        
        XCTAssertEqual(testObject.cardsCorrect, 0)
        XCTAssertEqual(testObject.cardsIncorrect, 0)
        XCTAssertEqual(testObject.responseTimes, [])
    }

    func test_resetStatistics_setsValuesToZero() {
        let testObject = DataStore()
        testObject.cardsCorrect = Int.random(in: 100...1000)
        testObject.cardsIncorrect = Int.random(in: 2000...5000)
        testObject.responseTimes = [Double.random(in: 1...20)]
        
        testObject.resetStatistics()
        
        XCTAssertEqual(testObject.cardsCorrect, 0)
        XCTAssertEqual(testObject.cardsIncorrect, 0)
        XCTAssertEqual(testObject.responseTimes, [])
    }
    
    func test_percentCorrect_returnsCorrectAnswer() {
        let correct = Int.random(in: 1...10)
        let incorrect = Int.random(in: 1...10)
        
        let testObject = DataStore()
        testObject.cardsCorrect = correct
        testObject.cardsIncorrect = incorrect
        
        let expectedPct = Double(correct) / (Double(correct) + Double(incorrect))
                
        let actualPct = testObject.percentCorrect
        XCTAssertTrue(actualPct <= 1)
        XCTAssertTrue(actualPct >= 0)
        XCTAssertEqual(actualPct, expectedPct)
    }
    
    func test_percentCorrect_WhenNoAnswers_ThenReturnsZero() {
        let testObject = DataStore()
        testObject.cardsCorrect = 0
        testObject.cardsIncorrect = 0
        
        let expectedPct = 0.0
        
        XCTAssertEqual(testObject.percentCorrect, expectedPct)
    }
    
    func test_averageResponseTime_returnsCorrectAnswer() {
        let responseCount = Int.random(in: 1...50)
        let responseTimes: [Double] = (1...responseCount).map { _ in Double.random(in: 0.01...3.0) }
        
        let responseSum: Double = responseTimes.reduce(0.0) { (sum, time) -> Double in
            sum + time
        }
        let expectedAverage = responseSum / Double(responseCount)
        
        let testObject = DataStore()
        testObject.responseTimes = responseTimes
        
        XCTAssertEqual(testObject.averageResponseTime, expectedAverage)
    }
    
    func test_averageResponseTime_WhenNoResponses_ThenReturnsZero() {
        let testObject = DataStore()
        testObject.responseTimes = []
        
        XCTAssertEqual(testObject.averageResponseTime, 0.0)
    }
}

class DataStoreMock: DataStore {
    var resetStatistics_counter = 0
    override func resetStatistics() {
        resetStatistics_counter += 1
    }
    
    var percentCorrect_returnValue = 0.0
    override var percentCorrect: Double {
        return percentCorrect_returnValue
    }
    
    var averageResponseTime_returnValue = 0.0
    override var averageResponseTime: Double {
        return averageResponseTime_returnValue
    }
}
