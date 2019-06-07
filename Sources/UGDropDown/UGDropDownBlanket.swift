import Foundation
import UIKit

protocol UGDropDownBlanketDelegate: class {
    func blanketViewTapped()
}

class UGDropDownBlanket: UIView {
    private var blanketOpacity: CGFloat = 0.3
    private weak var delegate: UGDropDownBlanketDelegate?

    init(frame: CGRect, blanketColor: UIColor, blanketOpacity: CGFloat, shouldCloseOnTap: Bool, delegate: UGDropDownBlanketDelegate?) {
        self.blanketOpacity = blanketOpacity
        self.delegate = delegate
        super.init(frame: frame)
        self.backgroundColor = blanketColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.blanketViewTapped))
        self.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    func setInitialState() {
        self.alpha = 0.0
        self.isHidden = true
    }

    func prepareBlanketToShow() {
        self.alpha = 0.0
        self.isHidden = false
    }

    func show() {
        self.alpha = self.blanketOpacity
        self.isHidden = false
    }

    func hide() {
        self.alpha = 0.0
    }

    @objc func blanketViewTapped() {
        self.delegate?.blanketViewTapped()
    }
}
