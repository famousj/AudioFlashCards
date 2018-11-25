import Foundation

class DataStore {
    static let sharedInstance = DataStore()
    
    var cardsCorrect: Int = 0
    var cardsIncorrect: Int = 0
    var responseTimes: [Double] = []
    
    func resetStatistics() {
        cardsCorrect = 0
        cardsIncorrect = 0
        responseTimes = []
    }
    
    var percentCorrect: Double {
        let sum = cardsCorrect + cardsIncorrect
        guard sum > 0 else { return 0.0 }
        
        let correctDouble = Double(cardsCorrect)
        return correctDouble / Double(sum)
    }
    
    var averageResponseTime: Double {
        guard responseTimes.count > 0 else { return 0.0 }
        let responseSum = responseTimes.reduce(0.0) { (sum, time) -> Double in
            sum + time
        }
        
        return responseSum / Double(responseTimes.count)
    }
}
