//
//  SignupViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 22.09.2021.
//

import UIKit

final class SignupViewController: UIViewController {

    private let genderString = ["m", "f"]
    
    @IBOutlet weak var usernameTextField: TextFieldWithImage!
    @IBOutlet weak var passwordTextField: TextFieldWithImage!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: TextFieldWithImage!
    @IBOutlet weak var cardNumberTextField: TextFieldWithImage!
    @IBOutlet weak var bioTextField: TextFieldWithImage!
    
    
    @IBAction func finishRegisterButtonHandler(_ sender: Any) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text,
            let cardNumber = cardNumberTextField.text,
            let bio = bioTextField.text
        else {
            DispatchQueue.main.async {
                showAlert(forController: self, message: "Не удалось зарегестрироваться")
            }
            log(message: "Ошибка чтения данных регистрации", .Error)
            return
        }
        
        let gender = genderString[genderSegmentControl.selectedSegmentIndex]
        
        let auth = RequestFactory.instance.makeAuthRequestFactory()
        let data = UserData(id: 123,
                            username: username,
                            password: password,
                            email: email,
                            gender: gender,
                            card: cardNumber,
                            bio: bio)
        auth.signup(data: data) { response in
            switch response.result {
            case .success(let signup):
                if signup.result == 0 {
                    DispatchQueue.main.async {
                        showAlert(forController: self, message: signup.userMessage)
                    }
                    log(message: signup.userMessage, .Warning)
                } else {
                    log(message: "\(signup)", .Success)
                }
                
                
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(forController: self, message: error.localizedDescription)
                }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
