import Foundation


class CardPresenter {
    let view: CardView
    let cardModel: CardModel
    init(cardModel: CardModel, view: CardView) {
        self.cardModel = cardModel
        
        self.view = view
        view.delegate = self
        view.renderCard(cardModel.nextCard())
    }
}

extension CardPresenter: CardViewDelegate {
    func cardViewEvent_gesturedRevealAnswer() {
        view.renderAnswerShown(true)
    }
    
    func cardViewEvent_gesturedDoneWithCard() {
        view.renderCard(cardModel.nextCard())
    }
}
