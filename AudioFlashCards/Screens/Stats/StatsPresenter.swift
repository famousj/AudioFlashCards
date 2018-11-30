import Foundation

protocol StatsPresenterDelegate: class {
    func statsPresenterEvent_resetStatsRequested()
    func statsPresenterEvent_closeRequested()
}

class StatsPresenter {
    weak var delegate: StatsPresenterDelegate?
    
    let statsModel: StatsModel
    
    init(statsModel: StatsModel, statsView: StatsView) {
        self.statsModel = statsModel
        statsView.delegate = self
        
        statsView.renderResponseTime(statsModel.averageResponseTime)
        statsView.renderPercentCorrect(statsModel.percentCorrect)
    }
    
    func resetStatistics() {
        statsModel.resetStatistics()
        
        // TODO Reload the view
    }
}

extension StatsPresenter: StatsViewDelegate {
    func statsViewEvent_gesturedToResetStats() {
        delegate?.statsPresenterEvent_resetStatsRequested()
    }
    
    func statsViewEvent_gesturedToClose() {
        delegate?.statsPresenterEvent_closeRequested()
    }
}
