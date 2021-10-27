//
//  Utils.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 23.09.2021.
//

import UIKit

func showAlertController(forController controller: UIViewController,
                         message text: String,
                         handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: "Ошибка",
                                  message: text,
                                  preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "OK",
                                  style: .cancel,
                                  handler: handler))

    controller.present(alert,
                       animated: true,
                       completion: nil)
}

func ConvertPriceToString(price: Int) -> String {
    return "\(price) ₽"
}
