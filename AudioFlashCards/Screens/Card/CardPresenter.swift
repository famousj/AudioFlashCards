import Foundation

protocol CardPresenterDelegate: class {
    func cardPresenterEvent_errorListeningForAnswer(error: Error)
    func cardPresenterEvent_presentStatistics()
}

class CardPresenter {
    let view: CardView
    let cardModel: CardModel
    
    weak var delegate: CardPresenterDelegate?
    
    init(cardModel: CardModel, view: CardView) {
        self.cardModel = cardModel
        self.view = view
        
        view.delegate = self
        cardModel.delegate = self
    }
    
    func showNextCard() {
        guard let nextCard = cardModel.nextCard() else { return }
        
        view.renderCard(nextCard)
        cardModel.startListeningForAnswer()
    }
}

extension CardPresenter: CardViewDelegate {
    func cardViewEvent_gesturedViewStatistics() {
        delegate?.cardPresenterEvent_presentStatistics()
    }
    
    func cardViewEvent_gesturedRevealAnswer() {
        view.renderAnswerShown(answerIsCorrect: false)
    }
    
    func cardViewEvent_gesturedDoneWithCard() {
        view.renderInstructionsHidden(isHidden: true)
        showNextCard()
    }
}

extension CardPresenter: CardModelDelegate {
    
    func cardModelEvent_textRecognized(text: String) {
        view.renderRecognitionText(text: text)
    }
    
    func cardModelEvent_correctAnswerRecognized() {
        view.renderAnswerShown(answerIsCorrect: true)
    }
    
    func cardModelEvent_wrongAnswerRecognized() {
        view.renderAnswerShown(answerIsCorrect: false)
    }
    
    func cardModelEvent_errorListeningForAnswer(error: Error) {
        delegate?.cardPresenterEvent_errorListeningForAnswer(error: error)
    }
}
