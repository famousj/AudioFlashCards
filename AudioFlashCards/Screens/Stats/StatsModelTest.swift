import XCTest
@testable import AudioFlashCards

class StatsModelTest: XCTestCase {
    func test_resetStatistics_callsDataStore() {
        let dataStore = DataStoreMock()
        let testObject = StatsModel(dataStore: dataStore)
        
        testObject.resetStatistics()
        
        XCTAssertEqual(dataStore.resetStatistics_counter, 1)
    }
    
    func test_percentCorrect_returnsCorrectAnswer() {
        let dataStore = DataStoreMock()
        let expectedPct = Double.random(in: 0...1)
        dataStore.percentCorrect_returnValue = expectedPct
        
        let testObject = StatsModel(dataStore: dataStore)
        
        XCTAssertEqual(testObject.percentCorrect, expectedPct)
    }
    
    func test_averageAnswerTime_returnsCorrectAnswer() {
        let dataStore = DataStoreMock()
        let expectedAverageResponseTime = Double.random(in: 0.5...5.0)
        dataStore.averageResponseTime_returnValue = expectedAverageResponseTime
        
        let testObject = StatsModel(dataStore: dataStore)
        
        XCTAssertEqual(testObject.averageResponseTime, expectedAverageResponseTime)
    }
}
