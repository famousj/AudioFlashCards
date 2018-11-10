import Foundation

class CardModel {
    
    func nextCard() -> Card {
        return Card(num1: 6, num2: 8, operation: "+", answer: 14)
    }
}
