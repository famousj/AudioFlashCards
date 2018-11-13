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
        
        let verticalMargin: CGFloat = 60
        
        var constraints: [NSLayoutConstraint] = []
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapRecognizer)
        
        backgroundColor = .blue
        
        let problemContainerView = problemView
        addSubview(problemContainerView)
        problemContainerView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(problemContainerView.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin))
        constraints += createHorizontalAnchorConstraints(problemContainerView, constant: horizontalMargin)
        
        
        
        
        setupLabel(instructionsLabel, font: Fonts.instructionFont)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        addSubview(instructionsLabel)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(instructionsLabel, constant: horizontalMargin))
        
        let verticalSpacing: CGFloat = 32
        constraints.append(instructionsLabel.topAnchor.constraint(equalTo: problemContainerView.bottomAnchor, constant: verticalSpacing))
        constraints.append(constrainTopToBottom(bottomView: instructionsLabel, topView: problemContainerView))
        
        
        constraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin))
        
        //
        //        setupLabel(speechRecognitionLabel, font: Fonts.speechRecognitionFont)
        //        speechRecognitionLabel.backgroundColor = .yellow
        //        speechRecognitionLabel.numberOfLines = 0
        //        addSubview(speechRecognitionLabel)
        //        constraints.append(contentsOf: createHorizontalAnchorConstraints(speechRecognitionLabel, constant: horizontalMargin))
        //        constraints.append(speechRecognitionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin))
        
        constraints.forEach{ $0.isActive = true }
    }
    
    var problemView: UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        var constraints: [NSLayoutConstraint] = []
        
        let multiplier: CGFloat = 1/5
        
        setupLabel(num1Label, font: Fonts.numberFont)
        num1Label.backgroundColor = .orange
        num1Label.textAlignment = .center
        containerView.addSubview(num1Label)
        constraints += [num1Label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        bottomConstraint(item: num1Label, toItem: containerView, multiplier: multiplier*1)]
        
        setupLabel(num2Label, font: Fonts.numberFont)
        num2Label.backgroundColor = .brown
        containerView.addSubview(num2Label)
        constraints += [num2Label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        bottomConstraint(item: num2Label, toItem: containerView, multiplier: multiplier*2)]
        
        setupLabel(operationLabel, font: Fonts.numberFont)
        containerView.addSubview(operationLabel)
        constraints += [operationLabel.centerYAnchor.constraint(equalTo: num2Label.centerYAnchor),
                        operationLabel.rightAnchor.constraint(equalTo: num2Label.leftAnchor, constant: -horizontalMargin)]
        
        barView.backgroundColor = .black
        barView.isHidden = true
        containerView.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        constraints += createHorizontalAnchorConstraints(barView, constant: 0)
        constraints += [barView.heightAnchor.constraint(equalToConstant: 15),
                        bottomConstraint(item: barView, toItem: containerView, multiplier: multiplier*3)]

        setupLabel(answerLabel, font: Fonts.numberFont)
        answerLabel.backgroundColor = .brown
        containerView.addSubview(answerLabel)
        constraints += [answerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                        bottomConstraint(item: answerLabel, toItem: containerView, multiplier: multiplier*4)]
        
        constraints.forEach{ $0.isActive = true }
        
        return containerView
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
