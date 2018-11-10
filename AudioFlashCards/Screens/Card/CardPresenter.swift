import Foundation


class CardPresenter {
    init(cardModel: CardModel, view: CardView) {
        view.delegate = self
        view.renderCard(cardModel.nextCard())
    }
}

extension CardPresenter: CardViewDelegate {
    func cardViewEvent_gesturedTap() {
        
    }
}
