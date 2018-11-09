import UIKit

class CardController: UIViewController {
    let cardPresenter: CardPresenter
    
    init() {
        let cardModel = CardModel()
        let cardView = CardView()
        cardPresenter = CardPresenter(cardModel: cardModel, view: cardView)
        
        super.init(nibName: nil, bundle: nil)
        
        view = cardView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
