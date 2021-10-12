//
//  EditUserDataViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 23.09.2021.
//

import UIKit

final class EditUserDataViewController: UIViewController {
    
    private let genderStrings = ["m", "f"]
    
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
                            password: "mYp@ssw0rd",
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
        
        if let genderIndex = genderStrings.firstIndex(of: data.gender) {
            genderSegmentControl.selectedSegmentIndex = genderIndex
        } else {
            log(message: "Не удалось выбрать пол пользователя", .Error)
        }
    }
    
    @IBAction func changeUserDataButtonHandler(_ sender: Any) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let email = emailTextField.text,
            let cardNumber = cardNumberTextField.text,
            let bio = bioTextField.text
        else {
            DispatchQueue.main.async {
                showAlert(forController: self, message: "Не удалось обновить данные")
            }
            log(message: "Ошибка введенных данных", .Error)
            return
        }
        
        let gender = genderStrings[genderSegmentControl.selectedSegmentIndex]
        
        let auth = RequestFactory.shared.makeAuthRequestFactory()
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
                        showAlert(forController: self, message: "Не удалось обновить данные")
                    }
                    log(message: "Не удалось обновить данные", .Warning)
                } else {
                    log(message: "\(changedData)", .Success)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(forController: self, message: error.localizedDescription)
                }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    @IBAction func exitButtonHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StartScreen")
        self.present(mainViewController,
                     animated: true,
                     completion: .none)
    }
}
