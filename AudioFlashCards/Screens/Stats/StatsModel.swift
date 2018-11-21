import Foundation

class StatsModel {
    
    let dataStore: DataStore
    
    convenience init() {
        self.init(dataStore: DataStore.sharedInstance)
    }
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func resetStatistics() {
        dataStore.resetStatistics()
    }
    
    // TODO
    var percentCorrect: Double {
        return 0.004
    }
    
    // TODO
    var averageAnswerTime: Double {
        return 0.42
    }
}
