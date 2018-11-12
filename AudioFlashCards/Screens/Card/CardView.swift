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
        instructionsLabel.isHidden = isHidden
    }
    
    func renderRecognitionText(text: String) {
        speechRecognitionLabel.text = text
    }
}

private extension CardView {
    func layout() {
        let horizontalMargin: CGFloat = 32

        let verticalMargin: CGFloat = 60
        let numberMargin: CGFloat = horizontalMargin * 2
        
        var constraints: [NSLayoutConstraint] = []
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapRecognizer)
        
        backgroundColor = .white

        setupLabel(num1Label, font: Fonts.numberFont)
        num1Label.textAlignment = .right
        addSubview(num1Label)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(num1Label, constant: numberMargin))
        constraints.append(num1Label.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin))

        setupLabel(num2Label, font: Fonts.numberFont)
        addSubview(num2Label)
        constraints.append(createRightAnchorConstraint(num2Label, superview: self, constant: numberMargin))
        constraints.append(constrainTopToBottom(bottomView: num2Label, topView: num1Label))

        setupLabel(operationLabel, font: Fonts.numberFont)
        addSubview(operationLabel)
        constraints.append(operationLabel.rightAnchor.constraint(equalTo: num2Label.leftAnchor, constant: -horizontalMargin))
        constraints.append(operationLabel.bottomAnchor.constraint(equalTo:num2Label.bottomAnchor))

        barView.backgroundColor = .black
        barView.isHidden = true
        addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(barView.heightAnchor.constraint(equalToConstant: 15))
        constraints.append(contentsOf: createHorizontalAnchorConstraints(barView, constant: horizontalMargin))
        constraints.append(constrainTopToBottom(bottomView: barView, topView: num2Label))
    
        setupLabel(answerLabel, font: Fonts.numberFont)
        answerLabel.textAlignment = .right
        addSubview(answerLabel)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(answerLabel, constant: numberMargin))
        constraints.append(constrainTopToBottom(bottomView: answerLabel, topView: barView))
        
        setupLabel(instructionsLabel, font: Fonts.instructionFont)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        addSubview(instructionsLabel)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(instructionsLabel, constant: horizontalMargin))
        constraints.append(constrainTopToBottom(bottomView: instructionsLabel, topView: answerLabel))
        
        setupLabel(speechRecognitionLabel, font: Fonts.speechRecognitionFont)
        speechRecognitionLabel.backgroundColor = .yellow
        speechRecognitionLabel.numberOfLines = 0
        addSubview(speechRecognitionLabel)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(speechRecognitionLabel, constant: horizontalMargin))
        constraints.append(speechRecognitionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin))
        constraints.forEach{ $0.isActive = true }
    }
    
    func setupLabel(_ label: UILabel, font: UIFont) {
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createHorizontalAnchorConstraints(_ view: UIView, constant: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = view.superview else { return [] }
        
        return [createLeftAnchorConstraint(view, superview: superview, constant: constant),
                createRightAnchorConstraint(view, superview: superview, constant: constant) ]
    }
    
    func createLeftAnchorConstraint(_ view: UIView, superview: UIView, constant: CGFloat) -> NSLayoutConstraint {
        return view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant)
    }

    func createRightAnchorConstraint(_ view: UIView, superview: UIView, constant: CGFloat) -> NSLayoutConstraint {
        return view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant)
    }
    
    func constrainTopToBottom(bottomView: UIView, topView: UIView) -> NSLayoutConstraint {
        let verticalSpacing: CGFloat = 32
        return bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: verticalSpacing)
    }
}
