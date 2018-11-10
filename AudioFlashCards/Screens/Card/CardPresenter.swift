import Foundation


class CardPresenter {
    let view: CardView
    let cardModel: CardModel
    init(cardModel: CardModel, view: CardView) {
        self.cardModel = cardModel
        
        self.view = view
        view.delegate = self
        showNextCard()
    }
    
    private func showNextCard() {
        guard let nextCard = cardModel.nextCard() else { return }
        
        view.renderCard(nextCard)
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
