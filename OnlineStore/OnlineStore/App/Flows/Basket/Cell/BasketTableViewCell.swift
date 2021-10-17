//
//  BasketTableViewCell.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 13.10.2021.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var countStepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var basketItemIndex = -1
    
    weak var basketDelegate: BasketViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        nameLabel.text = nil
        countTextField.text = nil
        countStepper.value = 0
        priceLabel.text = nil
    }
    
    func configure(basketItemAt index: Int) {
        basketItemIndex = index
        
        let basketItem = UserBasketManager.shared.basket[index]
        
        nameLabel.text = basketItem.product.name
        countTextField.text = "\(basketItem.count)"
        countStepper.value = Double(basketItem.count)
        priceLabel.text = ConvertPriceToString(price: basketItem.product.price)
    }
    
    @IBAction func stepperValueChangedHandler(_ sender: Any) {
        guard basketItemIndex >= 0 else { return }
        
        let basketItem = UserBasketManager.shared.basket[basketItemIndex]
        
        let oldCount = basketItem.count
        let newCount = Int(countStepper.value)
        
        countTextField.text = newCount.description
        
        let isIncreaseCount = oldCount < newCount
        
        isIncreaseCount ?
        basketDelegate?
            .increaseBasketCost(by: basketItem.product.price)
        : basketDelegate?
            .decreaseBasketCost(by: basketItem.product.price)
        
        UserBasketManager.shared
            .changeCount(at: basketItemIndex, increase: isIncreaseCount)
    }
}
