import Foundation

class CardModel {
    var cardDeck: CardDeck
    
    convenience init() {
        let min = 0
        let max = 9
        self.init(cardDeck: CardDeck.additionDeck(min: min, max: max))
    }
    
    init(cardDeck: CardDeck) {
        self.cardDeck = cardDeck
    }
    
    func nextCard() -> Card? {
        let nextCard = cardDeck.cards.first
        cardDeck = cardDeck.dropFirstCard()
        return nextCard
    }
}
