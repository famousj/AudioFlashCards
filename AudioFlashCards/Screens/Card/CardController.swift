import UIKit
import Speech

class CardController: UIViewController {
    let cardPresenter: CardPresenter
    
    convenience init() {
        let cardModel = CardModel()
        let cardView = CardView()
        let cardPresenter = CardPresenter(cardModel: cardModel, view: cardView)
        self.init(cardView: cardView, cardPresenter: cardPresenter)
    }
    
    init(cardView: CardView, cardPresenter: CardPresenter) {
        self.cardPresenter = cardPresenter
        
        super.init(nibName: nil, bundle: nil)
        
        view = cardView
        cardPresenter.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SFSpeechRecognizer.requestAuthorization { (status) in
            // TODO handle when request comes back "unauthorized"
        }

        cardPresenter.showNextCard()
    }
    
    private func displayAlert(title: String, error: Error) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension CardController: CardPresenterDelegate {
    func cardPresenterEvent_errorListeningForAnswer(error: Error) {
        displayAlert(title: "Error Listening", error: error)
    }
}
