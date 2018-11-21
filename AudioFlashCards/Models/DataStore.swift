import Foundation

class DataStore {
    static let sharedInstance = DataStore()
    
    var cardsCorrect: Int = 0
    var cardsIncorrect: Int = 0
    var avgResponseTime: Double = 0
    
    func resetStatistics() {
        cardsCorrect = 0
        cardsIncorrect = 0
        avgResponseTime = 0
    }
}
