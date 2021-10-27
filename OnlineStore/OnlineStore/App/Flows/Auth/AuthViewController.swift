//
//  AuthViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 15.10.2021.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func signIn(login: String, password: String)
    func presentSignUpViewController()
    func showAlert(userMessage: String)
}

class AuthViewController: UIViewController {

    // MARK: - Subviews
    private lazy var signInView = SignInView()
    private lazy var signUpView = SignUpView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = UIColor.rgba(1.0,
                                       0.5,
                                       0,
                                       alpha: 1.0)
        label.text = "Online Store"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setGradientBackground()

        signInView.authDelegate = self
        signUpView.authDelegate = self
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
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(UpdateBackgroundLayerFrame),
                         name: UIDevice.orientationDidChangeNotification,
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
        NotificationCenter
            .default
            .removeObserver(self,
                            name: UIDevice.orientationDidChangeNotification,
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

    @objc private func UpdateBackgroundLayerFrame() {
        let viewFrameSize = self.view
            .frame
            .size

        self.view
            .layer
            .sublayers?[0]
            .frame = CGRect(x: 0.0,
                            y: 0.0,
                            width: viewFrameSize.width,
                            height: viewFrameSize.height)
    }

    // MARK: - Private methods
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        configureScrollView()
        configureTitleLabel()

        addSignInView()
        addSignUpView()
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
                .constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    private func configureTitleLabel() {
        scrollView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel
                .topAnchor
                .constraint(equalTo: scrollView.topAnchor,
                            constant: 100),
            titleLabel
                .centerXAnchor
                .constraint(equalTo: scrollView.centerXAnchor)
        ])
    }

    private func addSignInView() {
        scrollView.addSubview(signInView)

        signInView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            signInView
                .topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor,
                            constant: 50),
            signInView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            signInView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func addSignUpView() {
        scrollView.addSubview(signUpView)

        signUpView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            signUpView
                .topAnchor
                .constraint(equalTo: signInView.bottomAnchor,
                            constant: 20),
            signUpView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            signUpView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor),
            signUpView
                .bottomAnchor
                .constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setGradientBackground() {
        let viewFrameSize = self.view
            .frame
            .size

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.gradientBegin.cgColor, UIColor.gradientEnd.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: viewFrameSize.width,
                                height: viewFrameSize.height)

        self.view
            .layer
            .insertSublayer(gradient, at: 0)
    }
}

// MARK: - AuthViewController + AuthViewControllerDelegate
extension AuthViewController: AuthViewControllerDelegate {
    func signIn(login: String, password: String) {
        let auth = RequestFactory.shared.makeAuthRequestFactory()

        auth.login(userName: login,
                   password: password) { response in
            switch response.result {
            case .success(let login):
                if login.result == 0 {
                    let messageText = "Введены неверные данные авторизации"
                    DispatchQueue
                        .main
                        .async {
                            showAlertController(forController: self,
                                                message: messageText)
                        }
                    log(message: messageText, .Warning)
                } else {
                    DispatchQueue
                        .main
                        .async {
                            let storyboard = UIStoryboard(name: "Main", bundle: .none)
                            let mainTabController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
                            self.present(mainTabController,
                                         animated: true,
                                         completion: .none)
                        }

                    log(message: "\(login)", .Success)
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

    func presentSignUpViewController() {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: .none)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpScreen")
        self.present(signUpViewController,
                     animated: true,
                     completion: .none)
    }

    func showAlert(userMessage: String) {
        showAlertController(forController: self,
                            message: userMessage)
    }
}
