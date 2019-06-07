import Foundation
import UIKit

public enum UGDropDownState {
    case open
    case closed
}

public protocol UGDropDownDelegate: UITableViewDelegate {}
public protocol UGDropDownDataSource: UITableViewDataSource {}

public final class UGDropDown: UITableView {
    private var currentPosition: Int = 0
    private var state: UGDropDownState = .closed
    private var maxDropDownHeight: CGFloat
    private var cellRowHeight: CGFloat
    private var blanketView: UGDropDownBlanket?
    private var heightConstraint: NSLayoutConstraint?

    private var bottomInset: CGFloat {
        return self.maxDropDownHeight - self.cellRowHeight
    }

    public weak var dropDownDelegate: UGDropDownDelegate? {
        didSet {
            self.delegate = self.dropDownDelegate
        }
    }

    public weak var dropDownDataSource: UGDropDownDataSource? {
        didSet {
            self.dataSource = self.dropDownDataSource
        }
    }

    public init(frame: CGRect, style: UITableView.Style, rowHeight: CGFloat) {
        self.maxDropDownHeight = rowHeight
        self.cellRowHeight = rowHeight
        super.init(frame: frame, style: style)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    public func setMaxDropDownHeight(_ height: CGFloat) {
        self.maxDropDownHeight = height
    }

    public func setHeightConstraint(_ heightConstraint: NSLayoutConstraint) {
        self.heightConstraint = heightConstraint
    }

    public func setBlanket(withColor color: UIColor, opacity: CGFloat, shouldCloseOnTap: Bool) {
        self.createBlanketView(withColor: color, opacity: opacity, shouldCloseOnTap: shouldCloseOnTap)
    }

    private func createBlanketView(withColor color: UIColor, opacity: CGFloat, shouldCloseOnTap: Bool) {
        guard let superview = self.superview else {
            fatalError("UGDropDown should have parent view before setting blanket view")
        }

        guard self.blanketView == nil else {
            return
        }

        self.blanketView = UGDropDownBlanket(frame: .zero, blanketColor: color, blanketOpacity: opacity, shouldCloseOnTap: shouldCloseOnTap, delegate: self)
        superview.insertSubview(self.blanketView!, belowSubview: self)
        self.blanketView!.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.blanketView!.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.blanketView!.topAnchor.constraint(equalTo: superview.topAnchor),
            self.blanketView!.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.blanketView!.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        self.blanketView?.setInitialState()
    }

    public func setInitialState(withPosition position: Int) {
        self.isScrollEnabled = true
        self.scrollToRow(at: IndexPath(row: position, section: 0), at: .top, animated: false)
        self.isScrollEnabled = false
    }

    public func toggleDropDown() {
        self.toggleDropDown(withSelectedPosition: self.currentPosition)
    }

    public func toggleDropDown(withSelectedPosition position: Int) {
        guard let _ = self.heightConstraint else {
            fatalError("height constraint needs to be set before toggle can work")
        }
        let indexPath = IndexPath(row: position, section: 0)
        switch self.state {
        case .open:
            self.closeDropDown(withSelectedIndexPath: indexPath)
        case .closed:
            self.openDropDown(withSelectedIndexPath: indexPath)
        }
    }

    public func getCurrentPosition() -> Int {
        return self.currentPosition
    }

    public func getCurrentState() -> UGDropDownState {
        return self.state
    }

    public func isCurrentPosition(position: Int) -> Bool {
        return self.currentPosition == position
    }

    private func openDropDown(withSelectedIndexPath indexPath: IndexPath) {
        self.state = .open
        self.blanketView?.prepareBlanketToShow()
        self.isScrollEnabled = true
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint!.constant = self.maxDropDownHeight
            self.scrollToRow(at: indexPath, at: .none, animated: false)
            self.blanketView?.show()
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.reloadRows(at: [indexPath], with: .none)
        })
    }

    private func closeDropDown(withSelectedIndexPath indexPath: IndexPath) {
        self.state = .closed
        self.reloadRows(at: [indexPath], with: .none)
        self.isScrollEnabled = true
        self.contentInset.bottom = self.bottomInset
        UIView.animate(withDuration: 0.25, animations: {
            self.heightConstraint!.constant = self.cellRowHeight
            self.scrollToRow(at: indexPath, at: .top, animated: false)
            self.blanketView?.hide()
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.contentInset.bottom = 0.0
            self.blanketView?.isHidden = true
            self.isScrollEnabled = false
        })
    }
}

extension UGDropDown: UGDropDownBlanketDelegate {
    func blanketViewTapped() {
        self.toggleDropDown()
    }
}
