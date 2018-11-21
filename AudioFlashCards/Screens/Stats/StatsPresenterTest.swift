import XCTest
@testable import AudioFlashCards

class StatsPresenterTest: XCTestCase, StatsPresenterDelegate {

    override func setUp() {
        statsPresenterEvent_resetStatsRequested_counter = 0
    }
    
    func test_OnInit_SetsItselfToViewDelegate() {
        let view = StatsView()
        let testObject = StatsPresenter(statsModel: StatsModel(), statsView: view)
        
        XCTAssertTrue(view.delegate === testObject)
    }
    
    func test_OnInit_TellsViewToRenderStats() {
        let view = StatsViewMock()
        let model = StatsModelMock()
        let percentCorrect = Double.random(in: 0..<1)
        let averageResponseTime = Double.random(in: 5...30)
        model.percentCorrect_nextValue = percentCorrect
        model.averageAnswerTime_nextValue = averageResponseTime
        
        let _ = StatsPresenter(statsModel: model, statsView: view)
        
        XCTAssertEqual(view.renderAnswerTime_counter, 1)
        XCTAssertTrue(view.renderAnswerTime_paramAnswerTime == averageResponseTime)
        XCTAssertEqual(view.renderPercentCorrect_counter, 1)
        XCTAssertTrue(view.renderPercentCorrect_paramPercentCorrect == percentCorrect)
    }
    
    func test_WhenViewGesturesResetStats_ThenCallsDelegateMethod() {
        let testObject = StatsPresenter(statsModel: StatsModel(), statsView: StatsView())
        testObject.delegate = self
        
        testObject.statsViewEvent_gesturedToResetStats()
        
        XCTAssertEqual(statsPresenterEvent_resetStatsRequested_counter, 1)
    }
    
    func test_ResetStatistics_CallsModel() {
        let model = StatsModelMock()
        let testObject = StatsPresenter(statsModel: model, statsView: StatsView())
        
        testObject.resetStatistics()
        
        XCTAssertEqual(model.resetStatistics_counter, 1)
    }
    
    var statsPresenterEvent_resetStatsRequested_counter = 0
    func statsPresenterEvent_resetStatsRequested() {
        statsPresenterEvent_resetStatsRequested_counter += 1
    }
}

class StatsViewMock: StatsView {
    var renderPercentCorrect_counter = 0
    var renderPercentCorrect_paramPercentCorrect: Double?
    override func renderPercentCorrect(_ percentCorrect: Double) {
        renderPercentCorrect_counter += 1
        renderPercentCorrect_paramPercentCorrect = percentCorrect
    }
    
    var renderAnswerTime_counter = 0
    var renderAnswerTime_paramAnswerTime: Double?
    override func renderAnswerTime(_ answerTime: Double) {
        renderAnswerTime_counter += 1
        renderAnswerTime_paramAnswerTime = answerTime
    }
}

class StatsModelMock: StatsModel {
    
    var percentCorrect_nextValue: Double = 0.0
    override var percentCorrect: Double {
        return percentCorrect_nextValue
    }
    
    var averageAnswerTime_nextValue: Double = 0.0
    override var averageAnswerTime: Double {
        return averageAnswerTime_nextValue
    }
    
    var resetStatistics_counter = 0
    override func resetStatistics() {
        resetStatistics_counter += 1
    }
}
