//
//  EditUserDataViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 23.09.2021.
//

import UIKit

final class EditUserDataViewController: UIViewController {
    
    private let requestFactory = RequestFactory()
    
    
    
    private let genderString = ["m", "f"]
    
    @IBOutlet weak var usernameTextField: TextFieldWithImage!
    @IBOutlet weak var passwordTextField: TextFieldWithImage!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: TextFieldWithImage!
    @IBOutlet weak var cardNumberTextField: TextFieldWithImage!
    @IBOutlet weak var bioTextField: TextFieldWithImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = UserData(id: 123,
                            username: "Somebody",
                            password: "mypassword",
                            email: "some@some.ru",
                            gender: "m",
                            card: "9872389-2424-234224-234",
                            bio: "This is good! I think I will switch to another language")
        setUserData(data: data)
    }
    
    private func setUserData(data: UserData) {
        usernameTextField.text = data.username
        passwordTextField.text = data.password
        emailTextField.text = data.email
        cardNumberTextField.text = data.card
        bioTextField.text = data.bio
        genderSegmentControl.selectedSegmentIndex = data.gender == "m" ? 0 : 1
    }
    
    @IBAction func changeUserDataButtonHandler(_ sender: Any) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text,
            let cardNumber = cardNumberTextField.text,
            let bio = bioTextField.text
        else {
            return
        }
        
        let gender = genderString[genderSegmentControl.selectedSegmentIndex]
        
        let auth = requestFactory.makeAuthRequestFactory()
        let data = UserData(id: 123,
                            username: username,
                            password: password,
                            email: email,
                            gender: gender,
                            card: cardNumber,
                            bio: bio)
        
        auth.changeUserData(data: data) { response in
            switch response.result {
            case .success(let changedData):
                if changedData.result == 0 {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Не удалось обновить данные")
                    }
                }
                
                log(message: "\(changedData)", .Success)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
