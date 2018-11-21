import XCTest
@testable import AudioFlashCards

class StatsModelTest: XCTestCase {
    func test_resetStatistics_callsDataStore() {
        let dataStore = DataStoreMock()
        let testObject = StatsModel(dataStore: dataStore)
        
        testObject.resetStatistics()
        
        XCTAssertEqual(dataStore.resetStatistics_counter, 1)
    }
}
