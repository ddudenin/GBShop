//
//  UserDataView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit
import SwiftUI
import Firebase

class UserDataView: UIView {
    
    // MARK: - Public properties
    weak var signUpDelegate: SignUpViewControllerDelegate?
    // weak var editDataDelegate: SignUpViewControllerDelegate?
    
    // MARK: - Private properties
    private let genderStrings = ["m", "f"]
    
    // MARK: - Subviews
    private lazy var usernameTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "person")
        textfield.leftPadding = 10
        textfield.placeholder = "user name"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.isAccessibilityElement = true
        textfield.accessibilityIdentifier = "username"
        return textfield
    }()
    
    private lazy var passwordTextField: SecureTextFieldWithImage = {
        let textfield = SecureTextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "key")
        textfield.leftPadding = 10
        textfield.placeholder = "password"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.isAccessibilityElement = true
        textfield.accessibilityIdentifier = "sign up password"
        return textfield
    }()
    
    private lazy var emailTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "envelope.circle")
        textfield.leftPadding = 10
        textfield.placeholder = "email"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.isAccessibilityElement = true
        textfield.accessibilityIdentifier = "email"
        return textfield
    }()
    
    private lazy var genderSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["male", "female"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var cardNumberTextField: SecureTextFieldWithImage = {
        let textfield = SecureTextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "creditcard")
        textfield.leftPadding = 10
        textfield.placeholder = "credit card number"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.isAccessibilityElement = true
        textfield.accessibilityIdentifier = "credit card"
        return textfield
    }()
    
    private lazy var bioTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "text.bubble")
        textfield.leftPadding = 10
        textfield.placeholder = "bio"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.isAccessibilityElement = true
        textfield.accessibilityIdentifier = "bio"
        return textfield
    }()
    
    private lazy var userInputsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            usernameTextField,
            passwordTextField,
            emailTextField,
            genderSegmentControl,
            cardNumberTextField,
            bioTextField
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment =  .fill
        stack.spacing = 10
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
    
    // MARK: - Public methods
    func getUserData() -> UserData? {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text,
            let cardNumber = cardNumberTextField.text,
            let bio = bioTextField.text
        else {
            signUpDelegate?.showAlert(userMessage: "Не удалось зарегестрироваться")
            let message = "Ошибка чтения данных регистрации"
            log(message: message, .Error)
            Firebase.Crashlytics.crashlytics().log(message)
            assertionFailure(message)
            return nil
        }
        
        let gender = genderStrings[genderSegmentControl.selectedSegmentIndex]
        
        return UserData(id: 123,
                        username: username,
                        password: password,
                        email: email,
                        gender: gender,
                        card: cardNumber,
                        bio: bio)
    }
    
    func setUserData(userData: UserData) {
        usernameTextField.text = userData.username
        passwordTextField.text = userData.password
        emailTextField.text = userData.email
        cardNumberTextField.text = userData.card
        bioTextField.text = userData.bio
        
        if let genderIndex = genderStrings.firstIndex(of: userData.gender) {
            genderSegmentControl.selectedSegmentIndex = genderIndex
        } else {
            log(message: "Не удалось выбрать пол пользователя", .Error)
        }
    }
    
    // MARK: - Private methods
    private func setupView() {
        self.addSubview(userInputsStackView)
        
        NSLayoutConstraint.activate([
            userInputsStackView
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),
            userInputsStackView
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor,
                            constant: -10),
            userInputsStackView
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 10),
            userInputsStackView
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10)
        ])
    }
}

extension UserDataView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

struct UserDataView_Preview: PreviewProvider {
    static var previews: some View {
        let view = UserDataView()
        return Group {
            return Group {
                UIPreviewView(view)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 375, height: 500))
            }
        }
    }
}
