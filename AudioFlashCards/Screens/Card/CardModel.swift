import Foundation
import Speech

protocol CardModelDelegate: class {
    func cardModelEvent_errorListeningForAnswer(error: Error)
}

class CardModel {
    var cardDeck: CardDeck
    
    let numberRecognizer: NumberRecognizer
    
    weak var delegate: CardModelDelegate?
    
    convenience init() {
        let min = 0
        let max = 9
        let cardDeck = CardDeck.additionDeck(min: min, max: max)
        let numberRecognizer = NumberRecognizer()
        self.init(cardDeck: cardDeck, numberRecognizer: numberRecognizer)
    }
    
    init(cardDeck: CardDeck, numberRecognizer: NumberRecognizer) {
        self.cardDeck = cardDeck
        self.numberRecognizer = numberRecognizer
    }
    
    func nextCard() -> Card? {
        let nextCard = cardDeck.cards.first
        cardDeck = cardDeck.dropFirstCard()
        return nextCard
    }
    
    func startListeningForAnswer() {
        do {
            try numberRecognizer.startListening()
        } catch {
            delegate?.cardModelEvent_errorListeningForAnswer(error: error)
        }
    }
}
