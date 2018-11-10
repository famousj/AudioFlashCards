import Foundation

struct CardDeck {
    let cards: [Card]
    
    static func additionDeck(min: Int, max: Int) -> CardDeck {
        let cards = (min...max).flatMap { (i) in
            (min...max).map { (j) in
                Card.AdditionCard(num1: i, num2: j)
            }
        }
        return CardDeck(cards: cards.shuffled())
    }
    
    
}
