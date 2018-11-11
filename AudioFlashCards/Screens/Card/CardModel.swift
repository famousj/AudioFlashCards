import Foundation
import Speech

protocol CardModelDelegate: class {
    func cardModelEvent_errorListeningForAnswer(error: Error)
    func cardModelEvent_textRecognized(text: String)
    func cardModelEvent_correctAnswerRecognized()
    func cardModelEvent_wrongAnswerRecognized()

}

class CardModel {
    var cardDeck: CardDeck
    
    private let numberRecognizer: NumberRecognizer
    private let numberFilter: NumberFilter
    
    private var currentCard: Card?
    
    weak var delegate: CardModelDelegate?
    
    convenience init() {
        let min = 0
        let max = 9
        let cardDeck = CardDeck.additionDeck(min: min, max: max)
        let numberRecognizer = NumberRecognizer()
        let numberFilter = NumberFilter()
        self.init(cardDeck: cardDeck, numberRecognizer: numberRecognizer, numberFilter: numberFilter)
    }
    
    init(cardDeck: CardDeck, numberRecognizer: NumberRecognizer, numberFilter: NumberFilter) {
        self.cardDeck = cardDeck
        self.numberRecognizer = numberRecognizer
        self.numberFilter = numberFilter
        numberRecognizer.delegate = self
    }
    
    func nextCard() -> Card? {
        currentCard = cardDeck.cards.first
        cardDeck = cardDeck.dropFirstCard()
        return currentCard
    }
    
    func startListeningForAnswer() {
        do {
            try numberRecognizer.startListening()
        } catch {
            delegate?.cardModelEvent_errorListeningForAnswer(error: error)
        }
    }
}

extension CardModel: NumberRecognizerDelegate {
    func numberRecognizerEvent_textRecognized(text: String) {
        delegate?.cardModelEvent_textRecognized(text: text)
        
        let textNumber = numberFilter.getNumberFromTranscriptionText(text)
        
        numberRecognizer.stopListening()
        
        guard let answer = currentCard?.answer else { return }
        
        if textNumber == answer {
            delegate?.cardModelEvent_correctAnswerRecognized()
        } else {
            delegate?.cardModelEvent_wrongAnswerRecognized()
        }
    }
}
