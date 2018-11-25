import UIKit

protocol StatsViewDelegate: class {
    func statsViewEvent_gesturedToResetStats()
}

class StatsView: UIView {
    weak var delegate: StatsViewDelegate?
    
    private let percentCorrectLabel = UILabel()
    private let responseTimeLabel = UILabel()
    
    private let percentCorrectLabelTitle = "Percent correct"
    private let responseTimeLabelTitle = "Avg. Time to Respond"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func resetButtonPressed() {
        delegate?.statsViewEvent_gesturedToResetStats()
    }
    
    func renderPercentCorrect(_ percentCorrect: Double) {
        let pctString = String(format: "%0.1f%% correct", percentCorrect*100)
        percentCorrectLabel.attributedText = statString(title: percentCorrectLabelTitle, stat: pctString)
    }
    
    func renderResponseTime(_ responseTime: Double) {
        let responseTimeString = String(format: "%.2f seconds", responseTime)
        responseTimeLabel.attributedText = statString(title: responseTimeLabelTitle, stat: responseTimeString)
    }
}

private extension StatsView {
    func layout() {
        let verticalMargin: CGFloat = 60
        let verticalSpacing: CGFloat = 32
        let horizontalMargin: CGFloat = 32
        var constraints: [NSLayoutConstraint] = []
        
        backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Statistics for Addition Cards"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.titleFont
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        constraints += Constraints.horizontalAnchorConstraints(titleLabel, constant: horizontalMargin)
        constraints.append(titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin))

        percentCorrectLabel.attributedText = statString(title: percentCorrectLabelTitle, stat: "")
        percentCorrectLabel.textAlignment = .left
        addSubview(percentCorrectLabel)
        percentCorrectLabel.translatesAutoresizingMaskIntoConstraints = false
        constraints += Constraints.horizontalAnchorConstraints(percentCorrectLabel, constant: horizontalMargin)
        constraints.append(Constraints.constrainTopToBottom(bottomView: percentCorrectLabel, topView: titleLabel, verticalSpacing: verticalSpacing))
        
        responseTimeLabel.attributedText = statString(title: responseTimeLabelTitle, stat: "")
        percentCorrectLabel.textAlignment = .left
        addSubview(responseTimeLabel)
        responseTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        constraints += Constraints.horizontalAnchorConstraints(responseTimeLabel, constant: horizontalMargin)
        constraints.append(Constraints.constrainTopToBottom(bottomView: responseTimeLabel, topView: percentCorrectLabel, verticalSpacing: verticalSpacing))
        
        let resetButton = UIButton(frame: .zero)
        resetButton.setTitle("Reset Statistics", for: .normal)
        resetButton.setTitleColor(Colors.buttonNormalColor, for: .normal)
        resetButton.setTitleColor(Colors.buttonHighlightedColor, for: .highlighted)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)

        resetButton.layer.cornerRadius = 4
        resetButton.layer.borderWidth = 1.0
        addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(Constraints.constrainTopToBottom(bottomView: resetButton, topView: responseTimeLabel, verticalSpacing: verticalSpacing))
        constraints.append(resetButton.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(resetButton.widthAnchor.constraint(equalToConstant: 200))
        
        constraints.forEach { $0.isActive = true }
    }
    
    func statString(title: String, stat: String) -> NSAttributedString {
        let categoryAttributes: [NSAttributedString.Key: Any] = [ .font : Fonts.statisticCategoryFont ]
        let categoryAttributedString = NSAttributedString(string: title, attributes: categoryAttributes)
        
        let statisticAttributes: [NSAttributedString.Key: Any] = [ .font : Fonts.statisticFont]
        let statisticAttributedString = NSAttributedString(string: stat, attributes: statisticAttributes)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(categoryAttributedString)
        attributedString.append(NSAttributedString(string: ":\t"))
        attributedString.append(statisticAttributedString)
        
        return attributedString
    }
}
