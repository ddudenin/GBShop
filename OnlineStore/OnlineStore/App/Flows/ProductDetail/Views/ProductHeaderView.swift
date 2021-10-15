//
//  ProductHeaderView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit
import SwiftUI

class ProductHeaderView: UIView {
    private(set) lazy var artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.secondarySystemFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray2.cgColor
        return imageView
    }()
    
    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 3
        label.textColor = .label
        return label
    }()
    
    private(set) lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var addToBasketButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "cart.fill.badge.plus"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(addToBasketButtonHandler(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    weak var productDelegate: ProductDetailViewControllerDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    func configure(product: ProductInfo) {
        self.artworkImageView.image = UIImage(systemName: "tag.circle")
        self.nameLabel.text = product.name
        self.priceLabel.text = ConvertPriceToString(price: product.price)
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.addSubview(artworkImageView)
        self.addSubview(nameLabel)
        self.addSubview(priceLabel)
        self.addSubview(addToBasketButton)
        
        NSLayoutConstraint.activate([
            artworkImageView.heightAnchor.constraint(equalToConstant: 100),
            artworkImageView.widthAnchor.constraint(equalToConstant: 100),
            artworkImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            artworkImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -16),
            artworkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4),
            
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: addToBasketButton.topAnchor, constant: -15),
            
            addToBasketButton.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 16),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        artworkImageView.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    @objc func addToBasketButtonHandler(_ sender: Any) {
        productDelegate?.addProductToBasket()
    }
}

struct ProductHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        let view = ProductHeaderView()
        view.nameLabel.text = "Игровой ноутбук"
        view.priceLabel.text = ConvertPriceToString(price: 48000)
        return UIPreviewView(view)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 150))
    }
}

