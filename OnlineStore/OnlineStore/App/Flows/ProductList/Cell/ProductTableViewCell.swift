//
//  ProductTableViewCell.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 03.10.2021.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    func configure(product: Product) {
        self.nameLabel.text = product.name
        self.priceLabel.text = ConvertPriceToString(price: product.price)
    }
}
