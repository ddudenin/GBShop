//
//  Utils.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 23.09.2021.
//

import UIKit

func showAlert(forController controller: UIViewController,
               message text: String,
               handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: "Ошибка",
                                  message: text,
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "OK",
                               style: .cancel,
                               handler: handler)
    alert.addAction(action)
    
    controller.present(alert, animated: true, completion: nil)
}

func ConvertPriceToString(price: Int) -> String {
    return "\(price) ₽"
}
