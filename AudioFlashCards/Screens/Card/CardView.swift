import UIKit

protocol CardViewDelegate: class {
    func cardViewEvent_gesturedRevealAnswer()
    func cardViewEvent_gesturedDoneWithCard()
}

class CardView: UIView {
    let num1Label = UILabel()
    let num2Label = UILabel()
    let operationLabel = UILabel()
    let barView = UIView()
    let answerLabel = UILabel()
    let instructionsLabel = UILabel()
    let speechRecognitionLabel = UILabel()
    
    let instructionsText_unanswered = "Just say the answer!"
    let instructionsText_answered = "Tap anywhere to continue"
    
    let horizontalMargin: CGFloat = 32
    
    var problemContainerView: UIView!
    
    weak var delegate: CardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func viewTapped() {
        if answerLabel.isHidden {
            delegate?.cardViewEvent_gesturedRevealAnswer()
        } else {
            delegate?.cardViewEvent_gesturedDoneWithCard()
        }
    }
    
    func renderCard(_ card: Card) {
        num1Label.text = String(card.num1)
        num2Label.text = String(card.num2)
        operationLabel.text = String(card.operation)
        barView.isHidden = false
        answerLabel.text = String(card.answer)
        answerLabel.isHidden = true
        speechRecognitionLabel.text = ""
        instructionsLabel.text = instructionsText_unanswered
    }
    
    func renderAnswerShown(answerIsCorrect: Bool) {
        if answerIsCorrect {
            answerLabel.textColor = .black
        } else {
            answerLabel.textColor = .red
        }
        answerLabel.isHidden = false
        
        instructionsLabel.text = instructionsText_answered
    }
    
    func renderInstructionsHidden(isHidden: Bool) {
        if isHidden {
            instructionsLabel.isHidden = isHidden
            
        } else {
            addSubview(instructionsLabel)
        }
    }
    
    func renderRecognitionText(text: String) {
        speechRecognitionLabel.text = text
        
        problemContainerView.sizeToFit()
    }
}

private extension CardView {
    func layout() {
        
        let verticalMargin: CGFloat = 60
        
        var constraints: [NSLayoutConstraint] = []
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapRecognizer)
        
        backgroundColor = .white
        
        self.problemContainerView = problemView
        addSubview(problemContainerView)
        problemContainerView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(problemContainerView.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin))
        constraints += Constraints.horizontalAnchorConstraints(problemContainerView, constant: horizontalMargin)
        
        setupLabel(instructionsLabel, font: Fonts.instructionFont)
        instructionsLabel.numberOfLines = 1
        instructionsLabel.textAlignment = .center
        addSubview(instructionsLabel)
        constraints += Constraints.horizontalAnchorConstraints(instructionsLabel, constant: horizontalMargin)
        
        constraints += [instructionsLabel.heightAnchor.constraint(equalToConstant: Fonts.instructionFont.pointSize),
                        Constraints.constrainTopToBottom(bottomView: instructionsLabel,
                                                         topView: problemContainerView,
                                                         verticalSpacing: verticalSpacing)]
        
        setupLabel(speechRecognitionLabel, font: Fonts.speechRecognitionFont)
        speechRecognitionLabel.backgroundColor = .yellow
        speechRecognitionLabel.numberOfLines = 0
        addSubview(speechRecognitionLabel)
        constraints += Constraints.horizontalAnchorConstraints(speechRecognitionLabel, constant: horizontalMargin)
        constraints += [Constraints.constrainTopToBottom(bottomView: speechRecognitionLabel,
                                                         topView: instructionsLabel,
                                                         verticalSpacing: verticalSpacing),
                        speechRecognitionLabel.heightAnchor.constraint(equalToConstant: 60),
                        speechRecognitionLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                                       constant: -verticalMargin)]
        
        constraints.forEach{ $0.isActive = true }
    }
    
    var problemView: UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        var constraints: [NSLayoutConstraint] = []

        let multiplier: CGFloat = 1/4

        let fontSize: CGFloat = DeviceSize.value(small: 75, medium: 85, large: 125, extraLarge: 175)
        let font = Fonts.numberFont.withSize(fontSize)
        
        setupLabel(num1Label, font: font)
        containerView.addSubview(num1Label)
        constraints += [num1Label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        num1Label.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: multiplier),
                        num1Label.topAnchor.constraint(equalTo: containerView.topAnchor)]
        
        setupLabel(num2Label, font: font)
        containerView.addSubview(num2Label)
        constraints += [num2Label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        num2Label.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: multiplier),
                        num2Label.topAnchor.constraint(equalTo: num1Label.bottomAnchor, constant: verticalSpacing)]

        setupLabel(operationLabel, font: font)
        containerView.addSubview(operationLabel)
        constraints += [operationLabel.centerYAnchor.constraint(equalTo: num2Label.centerYAnchor),
                        operationLabel.rightAnchor.constraint(equalTo: num2Label.leftAnchor,
                                                              constant: -horizontalMargin)]

        barView.backgroundColor = .black
        barView.isHidden = true
        containerView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        constraints += Constraints.horizontalAnchorConstraints(barView, constant: horizontalMargin)
        constraints += [barView.heightAnchor.constraint(equalToConstant: 15),
                        barView.topAnchor.constraint(equalTo: num2Label.bottomAnchor, constant: verticalSpacing)]

        setupLabel(answerLabel, font: font)
        containerView.addSubview(answerLabel)
        constraints += [answerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        answerLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: multiplier),
                        answerLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: verticalSpacing)]
        
        constraints.forEach{ $0.isActive = true }
        
        return containerView
    }
    
    var verticalSpacing: CGFloat {
        return DeviceSize.value(small: 20, medium: 28, large: 32, extraLarge: 64)
    }
    
    func bottomConstraint(item: UIView, toItem: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toItem, attribute: .bottom, multiplier: multiplier, constant: 0)
    }
    
    func setupLabel(_ label: UILabel, font: UIFont) {
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
    }

}
