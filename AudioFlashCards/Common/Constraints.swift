import UIKit

class Constraints {
    static func horizontalAnchorConstraints(_ view: UIView, constant: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = view.superview else { return [] }
        
        return [view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: constant),
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -constant) ]
    }
    
    static func constrainTopToBottom(bottomView: UIView, topView: UIView, verticalSpacing: CGFloat) -> NSLayoutConstraint {
        return bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: verticalSpacing)
    }
}
