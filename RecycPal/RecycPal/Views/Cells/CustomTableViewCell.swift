//
//  CustomTableViewCell.swift
//  RecycPal
//
//  Created by Denielle Abaquita on 1/15/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    let cellContentButton = UIButton()
    var selectCellHandler: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        // Button config
        cellContentButton.titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        cellContentButton.layer.cornerRadius = 10
        cellContentButton.contentHorizontalAlignment = .left
        cellContentButton.clipsToBounds = true
        cellContentButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        cellContentButton.titleLabel?.numberOfLines = 0
        cellContentButton.startAnimatingPressActions()
        contentView.addSubview(cellContentButton)
        
        cellContentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellContentButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 19),
            cellContentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 19),
            cellContentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            cellContentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -19)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    @objc func didTapButton(_ sender: Any) {
        if let selectCellHandler = selectCellHandler {
            selectCellHandler()
        }
    }
}

extension UIButton {
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }

    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }

    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }

    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
}
