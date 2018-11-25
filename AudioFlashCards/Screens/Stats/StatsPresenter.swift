import Foundation

protocol StatsPresenterDelegate: class {
    func statsPresenterEvent_resetStatsRequested()
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
    }
}

extension StatsPresenter: StatsViewDelegate {
    func statsViewEvent_gesturedToResetStats() {
        delegate?.statsPresenterEvent_resetStatsRequested()
    }
}
