//
//  ProfileViewController.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 16.10.2021.
//

import UIKit
import Firebase

protocol ProfileViewControllerDelegate: AnyObject {
    func updateUserData()
    func logout()
}

class ProfileViewController: UIViewController {

    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Your profile"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()

    private lazy var userDataView = UserDataView()

    private lazy var buttonsView = ButtonsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()

        buttonsView.profileDelegate = self

        setUserData()
    }

    // MARK: - Private methods
    private func configureView() {
        self.view.backgroundColor = .systemBackground

        addUserDataView()
        configureTitleLabel()
        addButtonsView()
    }

    private func addUserDataView() {
        self.view.addSubview(userDataView)

        userDataView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            userDataView
                .centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor),
            userDataView
                .centerYAnchor
                .constraint(equalTo: self.view.centerYAnchor),
            userDataView
                .leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor),
            userDataView
                .trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    private func addButtonsView() {
        self.view.addSubview(buttonsView)

        buttonsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsView
                .topAnchor
                .constraint(equalTo: userDataView.bottomAnchor,
                            constant: 10),
            buttonsView
                .centerXAnchor
                .constraint(equalTo: self.view.centerXAnchor)
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
                .constraint(equalTo: userDataView.centerXAnchor)
        ])
    }

    private func setUserData() {
        let userData = UserData(id: 123,
                                username: "Somebody",
                                password: "mYp@ssw0rd",
                                email: "some@some.ru",
                                gender: "m",
                                card: "9872389-2424-234224-234",
                                bio: "This is good! I think I will switch to another language")
        userDataView.setUserData(userData: userData)
    }

    private func logEventChangeData(success: Bool, content: String = "") {
        Analytics.logEvent(CustomAnalyticsEvent.changeUserData.rawValue,
                           parameters: [
                            AnalyticsParameterSuccess: success,
                            AnalyticsParameterContent: content
                           ])
    }
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func updateUserData() {
        guard let userData = userDataView.getUserData() else {
            showAlertController(forController: self,
                                message: "Не удалось прочитать обновленные данные")
            log(message: "Ошибка чтения введенных данных", .Error)
            return
        }

        let auth = RequestFactory.shared.makeAuthRequestFactory()

        auth.changeUserData(data: userData) { response in
            switch response.result {
            case .success(let changedData):
                if changedData.result == 0 {
                    DispatchQueue
                        .main
                        .async {
                            showAlertController(forController: self,
                                                message: "Не удалось обновить данные")
                        }
                    log(message: "Не удалось обновить данные", .Warning)
                    self.logEventChangeData(success: false,
                                            content: "Ошибка обновления пользовательских данных")
                } else {
                    log(message: "\(changedData)", .Success)
                    self.logEventChangeData(success: true)
                }

            case .failure(let error):
                DispatchQueue
                    .main
                    .async {
                        showAlertController(forController: self,
                                            message: error.localizedDescription)
                    }
                log(message: error.localizedDescription, .Error)
                self.logEventChangeData(success: false,
                                        content: error.localizedDescription)
            }
        }
    }

    func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "AuthScreen")
        self.present(mainViewController,
                     animated: true,
                     completion: .none)

        Firebase.Analytics.logEvent("Logout",
                                    parameters: nil)
    }
}
