import Foundation

protocol CardPresenterDelegate: class {
    func cardPresenterEvent_errorListeningForAnswer(error: Error)
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
    func cardViewEvent_gesturedRevealAnswer() {
        view.renderAnswerShown(true)
    }
    
    func cardViewEvent_gesturedDoneWithCard() {
        showNextCard()
    }
}

extension CardPresenter: CardModelDelegate {
    
    func cardModelEvent_errorListeningForAnswer(error: Error) {
        delegate?.cardPresenterEvent_errorListeningForAnswer(error: error)
    }
}
