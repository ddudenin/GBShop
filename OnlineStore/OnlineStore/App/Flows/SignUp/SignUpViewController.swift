//
//  SignUpViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func showAlert(userMessage: String)
    func signUp()
}

class SignUpViewController: UIViewController {
    
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
    
    private lazy var userDataView = UserDataView()
    private lazy var footnoteView = FootnoteView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        userDataView.signUpDelegate = self
        footnoteView.signUpDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillBeShown),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillBeHidden(notification:)),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter
            .default
            .removeObserver(self,
                            name: UIResponder.keyboardWillShowNotification,
                            object: nil)
        NotificationCenter
            .default
            .removeObserver(self,
                            name: UIResponder.keyboardWillHideNotification,
                            object: nil)
    }
    
    // MARK: - Attributes @objc
    @objc private func keyboardWillBeShown(notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let frame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else { return }
        
        let keyboardSize = frame
            .cgRectValue
            .size
        let contentInsets = UIEdgeInsets(top: 0.0,
                                         left: 0.0,
                                         bottom: keyboardSize.height,
                                         right: 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        self.scrollView.contentInset = UIEdgeInsets.zero
    }
        
    // MARK: - Private methods
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        configureScrollView()
        
        addUserDataView()
        
        configureTitleLabel()
        configureFootnoteView()
    }
    
    private func configureScrollView() {
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView
                .topAnchor
                .constraint(equalTo: self.view.topAnchor),
            scrollView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            scrollView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            scrollView
                .bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addUserDataView() {
        self.view.addSubview(userDataView)
        
        userDataView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userDataView
                .centerXAnchor
                .constraint(equalTo: scrollView.centerXAnchor),
            userDataView
                .centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            userDataView
                .leadingAnchor
                .constraint(equalTo: scrollView.leadingAnchor),
            userDataView
                .trailingAnchor
                .constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel
                .bottomAnchor
                .constraint(equalTo: userDataView.topAnchor,
                            constant: -10),
            titleLabel
                .centerXAnchor
                .constraint(equalTo: userDataView.centerXAnchor),
        ])
    }
    
    private func configureFootnoteView() {
        self.view.addSubview(footnoteView)
        
        footnoteView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footnoteView
                .topAnchor
                .constraint(equalTo: userDataView.bottomAnchor,
                            constant: 10),
            footnoteView
                .leadingAnchor
                .constraint(equalTo: scrollView.leadingAnchor),
            footnoteView
                .trailingAnchor
                .constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
}

extension SignUpViewController: SignUpViewControllerDelegate {
    func showAlert(userMessage: String) {
        showAlertController(forController: self,
                            message: userMessage)
    }
    
    func signUp() {
        guard let userData = userDataView.getUserData() else { return }
        
        let auth = RequestFactory.shared.makeAuthRequestFactory()
        
        auth.signup(data: userData) { response in
            switch response.result {
            case .success(let signup):
                if signup.result == 0 {
                    DispatchQueue
                        .main
                        .async {
                            showAlertController(forController: self,
                                                message: signup.userMessage)
                        }
                    log(message: signup.userMessage, .Warning)
                } else {
                    DispatchQueue
                        .main
                        .async {
                            let storyboard = UIStoryboard(name: "Main",
                                                          bundle: .none)
                            let mainViewController = storyboard.instantiateViewController(withIdentifier: "AuthScreen")
                            self.present(mainViewController,
                                         animated: true,
                                         completion: .none)
                        }
                    log(message: "\(signup)", .Success)
                }
                
            case .failure(let error):
                DispatchQueue
                    .main
                    .async {
                        showAlertController(forController: self,
                                            message: error.localizedDescription)
                    }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
}
