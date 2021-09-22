//
//  LoginFormController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 22.09.2021.
//

import UIKit

final class LoginFormController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextField: TextFieldWithImage!
    @IBOutlet weak var passwordTextField: TextFieldWithImage!
    
    private let requestFactory = RequestFactory()
    
    @objc private func keyboardWillBeShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        self.scrollView?.contentInset = UIEdgeInsets.zero
    }
    
    private func setGradientBackground() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.gradientBegin.cgColor, UIColor.gradientEnd.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc private func UpdateBackgroundLayerFrame() {
        self.view.layer.sublayers?[0].frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateBackgroundLayerFrame), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @IBAction func loginButtonHandler(_ sender: Any) {
        guard
            let login = self.loginTextField.text,
            let password = self.passwordTextField.text
        else {
            return
        }
        
        let auth = requestFactory.makeAuthRequestFactory()
        
        auth.login(userName: login, password: password) { response in
            switch response.result {
            case .success(let login):
                if login.result == 0 {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Не удалось авторизоваться")
                    }
                }
                
                log(message: "\(login)", .Success)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
                log(message: error.localizedDescription, .Error)
            }
        }
    }
    
    @IBAction func signupButtonHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupScreen")
        self.present(vc, animated: true, completion: .none)
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

extension LoginFormController: UITextFieldDelegate {
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
    }
    
    // Called on returnKey pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return false
    }
}
