//
//  SignUpViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func ShowAlert(text: String)
}

class SignUpViewController: UIViewController {
    
    // MARK: - Subviews
    private lazy var userDataView = UserDataView()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
        button.addTarget(self,
                         action: #selector(signUpButtonHandler(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        userDataView.signUpDelegate = self
    }
    
    // MARK: - Attributes @objc
    @objc func signUpButtonHandler(_ sender: Any) {
        guard let userData = userDataView.getUserData() else { return }
        
        let auth = RequestFactory.shared.makeAuthRequestFactory()
        
        auth.signup(data: userData) { response in
            switch response.result {
            case .success(let signup):
                if signup.result == 0 {
                    DispatchQueue.main.async {
                        showAlert(forController: self, message: signup.userMessage)
                    }
                    log(message: signup.userMessage, .Warning)
                } else {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: .none)
                        let mainViewController = storyboard.instantiateViewController(withIdentifier: "StartScreen")
                        self.present(mainViewController,
                                     animated: true,
                                     completion: .none)
                    }
                    
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
    
    // MARK: - Private methods
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        addUserDataView()
        configureSignUpButton()
    }
    
    private func addUserDataView() {
        self.view.addSubview(userDataView)
        
        userDataView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userDataView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            userDataView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            userDataView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            userDataView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
    
    private func configureSignUpButton() {
        self.view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: userDataView.bottomAnchor, constant: 30),
            signUpButton.centerXAnchor.constraint(equalTo: userDataView.centerXAnchor),
        ])
    }
}

extension SignUpViewController: SignUpViewControllerDelegate {
    func ShowAlert(text: String) {
        showAlert(forController: self, message: text)
    }
}
