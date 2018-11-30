import UIKit

class StatsController: UIViewController {
    let statsPresenter: StatsPresenter
    
    convenience init() {
        let view = StatsView()
        let presenter = StatsPresenter(statsModel: StatsModel(), statsView: view)

        self.init(statsView: view, statsPresenter: presenter)
    }
    
    init(statsView: StatsView, statsPresenter: StatsPresenter) {
        self.statsPresenter = statsPresenter

        super.init(nibName: nil, bundle: nil)
        
        statsPresenter.delegate = self
        view = statsView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StatsController {
    private func displayResetStatsAlert() {
        let alertController = UIAlertController(title: "Reset Statistics?", message: "Are you sure you would like to reset your statistics?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { _ in
            self.statsPresenter.resetStatistics()
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension StatsController: StatsPresenterDelegate {
    func statsPresenterEvent_closeRequested() {
        dismiss(animated: true, completion: nil)
    }
    
    func statsPresenterEvent_resetStatsRequested() {
        displayResetStatsAlert()
    }
}
