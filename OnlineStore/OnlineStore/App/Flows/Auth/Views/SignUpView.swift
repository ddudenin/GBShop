//
//  SignUpView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit
import SwiftUI

class SignUpView: UIView {

    // MARK: - Public properties
    weak var authDelegate: AuthViewControllerDelegate?

    // MARK: - Subviews
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.rgba(0.149,
                                       0.149,
                                       0.384,
                                       alpha: 1.0)
        label.text = "Don't have an account? Sign up |"
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.crop.square.filled.and.at.rectangle"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(signUpButtonHandler(_:)),
                         for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "sign up"
        return button
    }()

    private lazy var signUpStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            signUpLabel,
            signUpButton
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        stack.contentMode = .scaleToFill
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

            signUpButton
                .heightAnchor
                .constraint(equalToConstant: 25),
            signUpButton
                .widthAnchor
                .constraint(equalToConstant: 25)
        ])
    }

    @objc private func signUpButtonHandler(_ sender: Any) {
        authDelegate?.presentSignUpViewController()
    }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        let view = SignUpView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
