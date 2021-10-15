//
//  UserDataView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit
import SwiftUI

class UserDataView: UIView {
    
    // MARK: - Public properties
    weak var signUpDelegate: SignUpViewControllerDelegate?
    //weak var editDataDelegate: SignUpViewControllerDelegate?
    
    // MARK: - Private properties
    private let genderStrings = ["m", "f"]
    
    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Enter your data"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
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
        return textfield
    }()
    
    private lazy var passwordTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "key")
        textfield.leftPadding = 10
        textfield.placeholder = "password"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.delegate = self
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
        return textfield
    }()
    
    private lazy var genderSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["male","female"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var cardNumberTextField: TextFieldWithImage = {
        let textfield = TextFieldWithImage()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.leftImage = UIImage(systemName: "creditcard")
        textfield.leftPadding = 10
        textfield.placeholder = "credit card number"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.returnKeyType = .done
        textfield.delegate = self
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
        return textfield
    }()
    
    private lazy var userInputsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.contentMode = .scaleToFill
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(genderSegmentControl)
        stack.addArrangedSubview(cardNumberTextField)
        stack.addArrangedSubview(bioTextField)
        
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
            signUpDelegate?.ShowAlert(text: "Не удалось зарегестрироваться")
            log(message: "Ошибка чтения данных регистрации", .Error)
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
    
    // MARK: - Private
    private func setupView() {
        self.addSubview(userInputsStackView)
        
        NSLayoutConstraint.activate([
            userInputsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            userInputsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            userInputsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userInputsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
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

