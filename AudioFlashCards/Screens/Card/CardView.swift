import UIKit

class CardView: UIView {
    
    let horizontalMargin: CGFloat = 32
    let verticalSpacing: CGFloat = 32
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func renderCard(num1: Int, num2: Int) {
    //
    //    }
}

private extension CardView {
    func layout() {
        let verticalMargin: CGFloat = 60
        let numberMargin: CGFloat = horizontalMargin * 2
        
        var constraints: [NSLayoutConstraint] = []
        
        backgroundColor = .white
        
        let num1Label = createNumberLabel(number: 8)
        addSubview(num1Label)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(num1Label, constant: numberMargin))
        constraints.append(num1Label.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin))

        let num2Label = createNumberLabel(number: 6)
        addSubview(num2Label)
        constraints.append(createRightAnchorConstraint(num2Label, superview: self, constant: numberMargin))
        constraints.append(constrainTopToBottom(bottomView: num2Label, topView: num1Label))


        let operationLabel = createLabel(text: "+")
        addSubview(operationLabel)
        constraints.append(operationLabel.rightAnchor.constraint(equalTo: num2Label.leftAnchor, constant: -horizontalMargin))
        constraints.append(operationLabel.bottomAnchor.constraint(equalTo:num2Label.bottomAnchor))

        let barView = UIView()
        barView.backgroundColor = .black
        addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(barView.heightAnchor.constraint(equalToConstant: 15))
        constraints.append(contentsOf: createHorizontalAnchorConstraints(barView, constant: horizontalMargin))
        constraints.append(constrainTopToBottom(bottomView: barView, topView: num2Label))
    
        let answerLabel = createNumberLabel(number: 14)
        addSubview(answerLabel)
        constraints.append(contentsOf: createHorizontalAnchorConstraints(answerLabel, constant: numberMargin))
        constraints.append(constrainTopToBottom(bottomView: answerLabel, topView: barView))
        
        constraints.forEach{ $0.isActive = true }
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 100)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createNumberLabel(number: Int) -> UILabel {
        let label = createLabel(text: String(number))
        label.textAlignment = .right
        return label
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
        return bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: verticalSpacing)
    }
}
