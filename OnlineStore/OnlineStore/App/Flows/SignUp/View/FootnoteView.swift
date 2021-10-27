//
//  FootnoteView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 17.10.2021.
//

import UIKit
import SwiftUI

class FootnoteView: UIView {

    // MARK: - Public properties
    weak var signUpDelegate: SignUpViewControllerDelegate?

    // MARK: - Subviews
    private lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "By signing up, I agree to Store's Terms & Conditions and Privacy Policy"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .justified
        return label
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.fill.checkmark"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(signUpButtonHandler(_:)),
                         for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityIdentifier = "register"
        return button
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
        self.addSubview(agreementLabel)
        self.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            agreementLabel
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),
            agreementLabel
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 15),
            agreementLabel
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -15),

            signUpButton
                .topAnchor
                .constraint(equalTo: agreementLabel.bottomAnchor,
                            constant: 20),
            signUpButton
                .centerXAnchor
                .constraint(equalTo: self.centerXAnchor),
            signUpButton
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor,
                            constant: -10)
        ])
    }

    @objc private func signUpButtonHandler(_ sender: Any) {
        signUpDelegate?.signUp()
    }
}

struct FootnoteView_Preview: PreviewProvider {
    static var previews: some View {
        let view = FootnoteView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
