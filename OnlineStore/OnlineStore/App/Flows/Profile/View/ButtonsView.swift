//
//  ButtonsView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 16.10.2021.
//

import UIKit
import SwiftUI

class ButtonsView: UIView {

    // MARK: - Public properties
    weak var profileDelegate: ProfileViewControllerDelegate?

    // MARK: - Subviews
    private lazy var updateUserDataButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.clockwise.icloud.fill"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(updateUserDataButtonHandler(_:)),
                         for: .allEvents)
        return button
    }()

    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right.fill"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(exitButtonHandler(_:)),
                         for: .allEvents)
        return button
    }()

    private lazy var signUpStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            updateUserDataButton,
            exitButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    // MARK: - Private methods
    private func setupView() {
        self.addSubview(signUpStackView)

        NSLayoutConstraint.activate([
            signUpStackView
                .centerXAnchor
                .constraint(equalTo: self.centerXAnchor),
            signUpStackView
                .topAnchor
                .constraint(equalTo: self.topAnchor),
            signUpStackView
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor),

            exitButton
                .heightAnchor
                .constraint(equalToConstant: 50),
            exitButton
                .widthAnchor
                .constraint(equalToConstant: 50),

            updateUserDataButton
                .heightAnchor
                .constraint(equalToConstant: 50),
            updateUserDataButton
                .widthAnchor
                .constraint(equalToConstant: 50)
        ])
    }

    override func hitTest(_ point: CGPoint,
                          with event: UIEvent?) -> UIView? {
        guard !clipsToBounds
                && !isHidden
                && alpha > 0 else {
                    return nil
                }

        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)

            guard let result = member.hitTest(subPoint, with: event) else { continue }

            return result
        }

        return nil
    }

    @objc private func exitButtonHandler(_ sender: Any) {
        profileDelegate?.logout()
    }

    @objc private func updateUserDataButtonHandler(_ sender: Any) {
        profileDelegate?.updateUserData()
    }
}

struct ButtonsView_Preview: PreviewProvider {
    static var previews: some View {
        let view = ButtonsView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
