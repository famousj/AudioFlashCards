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
    
    var percentCorrect: Double {
        return dataStore.percentCorrect
    }
    
    var averageResponseTime: Double {
        return dataStore.averageResponseTime
    }
}
