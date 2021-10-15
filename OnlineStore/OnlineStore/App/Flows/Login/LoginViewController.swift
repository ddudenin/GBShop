//
//  LoginViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func SignIn(login: String, password: String)
    func ShowRegisterViewController()
    func ShowAlert(text: String)
}

class LoginViewController: UIViewController {
    
    // MARK: - Subviews
    private lazy var loginView = LoginView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setGradientBackground()
        
        loginView.loginDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateBackgroundLayerFrame), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    
    // MARK: - Attributes @objc
    @objc private func keyboardWillBeShown(notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let frame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        else {
            return
        }
        
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
    
    @objc private func UpdateBackgroundLayerFrame() {
        let viewFrameSize = self.view
            .frame
            .size
        
        self.view.layer.sublayers?[0].frame = CGRect(x: 0.0,
                                                     y: 0.0,
                                                     width: viewFrameSize.width,
                                                     height: viewFrameSize.height)
    }
    
    // MARK: - Private methods
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        configureScrollView()
        
        addLoginView()
    }
    
    private func configureScrollView() {
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addLoginView() {
        scrollView.addSubview(loginView)
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 5),
            loginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setGradientBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.gradientBegin.cgColor, UIColor.gradientEnd.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: self.view.frame.size.width,
                                height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - LoginViewController + LoginViewControllerDelegate
extension LoginViewController: LoginViewControllerDelegate {
    func SignIn(login: String, password: String) {
        let auth = RequestFactory.shared.makeAuthRequestFactory()
        
        auth.login(userName: login, password: password) { response in
            switch response.result {
            case .success(let login):
                if login.result == 0 {
                    let messageText = "Введены неверные данные авторизации"
                    DispatchQueue.main.async {
                        showAlert(forController: self, message: messageText)
                    }
                    log(message: messageText, .Warning)
                } else {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: .none)
                        let mainTabController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
                        self.present(mainTabController,
                                     animated: true,
                                     completion: .none)
                    }
                    
                    log(message: "\(login)", .Success)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(forController: self, message: error.localizedDescription)
                }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    func ShowRegisterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignUpScreen")
        self.present(signupViewController,
                     animated: true,
                     completion: .none)
    }
    
    func ShowAlert(text: String) {
        DispatchQueue.main.async {
            showAlert(forController: self, message: text)
        }
        log(message: "Ошибка чтения введенных данных", .Error)
    }
}
