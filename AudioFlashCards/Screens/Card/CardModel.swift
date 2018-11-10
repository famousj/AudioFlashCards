import Foundation

class CardModel {
    
    
    
    func nextCard() -> Card {
        return Card.AdditionCard(num1: 10, num2: 10)
    }
}
