//
//  LoginView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit
import SwiftUI

class LoginView: UIView {
    
    // MARK: - Public properties
    weak var loginDelegate: LoginViewControllerDelegate?
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        label.textColor = UIColor.rgba(1.0,
                                       0.5,
                                       0,
                                       alpha: 1.0)
        label.text = "Online Store"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
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
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 10
        stack.alignment = .center
        stack.contentMode = .scaleToFill
        stack.addArrangedSubview(loginTextField)
        stack.addArrangedSubview(passwordTextField)
        return stack
    }()
    
    private(set) lazy var signInButton: SignInButton = {
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
        button.addTarget(self, action: #selector(signInButtonHandler(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.rgba(0.149,
                                       0.149,
                                       0.384,
                                       alpha: 1.0)
        label.text = "Sign up |"
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.crop.square.filled.and.at.rectangle"), for: .normal)
        button.addTarget(self, action: #selector(signUpButtonHandler(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = .fill
        stack.contentMode = .scaleToFill
        stack.addArrangedSubview(signUpLabel)
        stack.addArrangedSubview(signUpButton)
        return stack
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(textFieldsStackView)
        self.addSubview(signInButton)
        self.addSubview(signUpStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            titleLabel.bottomAnchor.constraint(equalTo: self.textFieldsStackView.topAnchor, constant: -50),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textFieldsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textFieldsStackView.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -35),
            textFieldsStackView.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 10),
            textFieldsStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            
            signInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.widthAnchor.constraint(equalToConstant: 100),
            signInButton.bottomAnchor.constraint(equalTo: signUpStackView.topAnchor, constant: -16),
            
            loginTextField.leadingAnchor.constraint(lessThanOrEqualTo: textFieldsStackView.leadingAnchor),
            loginTextField.trailingAnchor.constraint(lessThanOrEqualTo: textFieldsStackView.trailingAnchor),
            
            passwordTextField.leadingAnchor.constraint(lessThanOrEqualTo: textFieldsStackView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(lessThanOrEqualTo: textFieldsStackView.trailingAnchor),
            
            signUpStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signUpStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 30),
            signUpButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func signInButtonHandler(_ sender: Any) {
        guard
            let login = loginTextField.text,
            let password = passwordTextField.text
        else {
            loginDelegate?.ShowAlert(text: "Не удалось прочитать данные авторизации")
            return
        }
        
        loginDelegate?.SignIn(login: login, password: password)
    }
    
    @objc func signUpButtonHandler(_ sender: Any) {
        loginDelegate?.ShowRegisterViewController()
    }
}

extension LoginView: UITextFieldDelegate {
    
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

struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        let view = LoginView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
