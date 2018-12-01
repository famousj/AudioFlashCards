import Foundation
import Speech
import os

protocol CardModelDelegate: class {
    func cardModelEvent_errorListeningForAnswer(error: Error)
    func cardModelEvent_textRecognized(text: String)
    func cardModelEvent_correctAnswerRecognized()
    func cardModelEvent_wrongAnswerRecognized()
    
}

class CardModel {
    var cardDeck: CardDeck
    
    private let numberRecognizer: AnswerRecognizer
    private let numberFilter: NumberFilter
    
    private var currentCard: Card?
    
    weak var delegate: CardModelDelegate?
    
    convenience init() {
        let min = 0
        let max = 9
        let cardDeck = CardDeck.additionDeck(min: min, max: max)
        let numberRecognizer = AnswerRecognizer()
        let numberFilter = NumberFilter()
        self.init(cardDeck: cardDeck, numberRecognizer: numberRecognizer, numberFilter: numberFilter)
    }
    
    init(cardDeck: CardDeck, numberRecognizer: AnswerRecognizer, numberFilter: NumberFilter) {
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
            os_log("Starting listening...")
            try numberRecognizer.startListening()
        } catch {
            delegate?.cardModelEvent_errorListeningForAnswer(error: error)
        }
    }
}

extension CardModel: NumberRecognizerDelegate {
    func numberRecognizerEvent_textRecognized(text: String) {
        os_log("Recognized text: %@", text)
        delegate?.cardModelEvent_textRecognized(text: text)
        
        os_log("Stopping listening...")
        numberRecognizer.stopListening()
    }
    
    func numberRecognizerEvent_receivedFinalResults(_ results: SFSpeechRecognitionResult) {
        os_log("Received final result: %@", log: .default, type: .debug, results.transcriptions)

        guard let answer = currentCard?.answer else { return }

        if numberFilter.getNumberFromRecognitionResults(results) == answer {
                 delegate?.cardModelEvent_correctAnswerRecognized()
        } else {
            delegate?.cardModelEvent_wrongAnswerRecognized()
        }
    }
}
