//
//  SignInView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit
import SwiftUI

class SignInView: UIView {
    
    // MARK: - Public properties
    weak var authDelegate: AuthViewControllerDelegate?
    
    // MARK: - Subviews
    private lazy var loginTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "person.circle")
        textfield.leftPadding = 10
        textfield.placeholder = "Enter your login"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.delegate = self
        textfield.returnKeyType = .continue
        return textfield
    }()
    
    private lazy var passwordTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "key")
        textfield.leftPadding = 10
        textfield.placeholder = "Enter your password"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.delegate = self
        textfield.returnKeyType = .done
        return textfield
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            loginTextField,
            passwordTextField
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.alignment = .fill
        stack.contentMode = .scaleToFill
        return stack
    }()
    
    private lazy var signInButton: SignInButton = {
        let button = SignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "Sign in"
        button.bgColor = UIColor.rgba(0.663,
                                      0.753,
                                      0.886,
                                      alpha: 1.0)
        button.textColor = UIColor.rgba(0.149,
                                        0.149,
                                        0.384,
                                        alpha: 1.0)
        button.borderColor = UIColor.rgba(0.075,
                                          0.059,
                                          0.251,
                                          alpha: 1.0)
        button.addTarget(self,
                         action: #selector(signInButtonHandler(_:)),
                         for: .touchUpInside)
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
        self.addSubview(textFieldsStackView)
        self.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            textFieldsStackView
                .centerXAnchor
                .constraint(equalTo: self.centerXAnchor),
            textFieldsStackView
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),
            textFieldsStackView
                .bottomAnchor
                .constraint(equalTo: signInButton.topAnchor,
                            constant: -25),
            textFieldsStackView
                .leadingAnchor
                .constraint(lessThanOrEqualTo: self.leadingAnchor,
                            constant: 10),
            textFieldsStackView
                .trailingAnchor
                .constraint(lessThanOrEqualTo: self.trailingAnchor,
                            constant: -10),
            
            signInButton
                .centerXAnchor
                .constraint(equalTo: self.centerXAnchor),
            signInButton
                .heightAnchor
                .constraint(equalToConstant: 40),
            signInButton
                .widthAnchor
                .constraint(equalToConstant: 100),
            signInButton
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor,
                            constant: -10)
        ])
    }
    
    @objc private func signInButtonHandler(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            authDelegate?.showAlert(userMessage: "Не удалось прочитать данные авторизации")
            log(message: "Ошибка чтения введенных данных", .Error)
            return
        }
        
        authDelegate?.signIn(login: login,
                             password: password)
    }
}

extension SignInView: UITextFieldDelegate {
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return false
    }
}

struct SignInView_Preview: PreviewProvider {
    static var previews: some View {
        let view = SignInView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
