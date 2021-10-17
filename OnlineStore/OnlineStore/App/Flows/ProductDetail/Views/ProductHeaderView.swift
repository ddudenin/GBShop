//
//  ProductHeaderView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit
import SwiftUI

class ProductHeaderView: UIView {

    // MARK: - Subviews
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.secondarySystemFill
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        let imageLayer = imageView.layer
        imageLayer.cornerRadius = 12
        imageLayer.borderWidth = 1
        imageLayer.borderColor = UIColor.systemGray2.cgColor
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

    // MARK: - Inits
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
        self.productImageView.image = UIImage(systemName: "tag.circle")
        self.nameLabel.text = product.name
        self.priceLabel.text = ConvertPriceToString(price: product.price)
    }

    // MARK: - Private methods
    private func setupView() {
        self.addSubview(productImageView)
        self.addSubview(nameLabel)
        self.addSubview(priceLabel)
        self.addSubview(addToBasketButton)

        NSLayoutConstraint.activate([
            productImageView
                .heightAnchor
                .constraint(equalToConstant: 100),
            productImageView
                .widthAnchor
                .constraint(equalToConstant: 100),
            productImageView
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 15),
            productImageView
                .bottomAnchor
                .constraint(lessThanOrEqualTo: self.bottomAnchor,
                            constant: -10),
            productImageView
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),

            nameLabel
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),
            nameLabel
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10),
            nameLabel
                .leadingAnchor
                .constraint(equalTo: productImageView.trailingAnchor,
                            constant: 10),
            nameLabel
                .bottomAnchor
                .constraint(equalTo: priceLabel.topAnchor,
                            constant: -5),

            priceLabel
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10),
            priceLabel
                .leadingAnchor
                .constraint(equalTo: productImageView.trailingAnchor,
                            constant: 10),
            priceLabel
                .bottomAnchor
                .constraint(equalTo: addToBasketButton.topAnchor,
                            constant: -10),

            addToBasketButton
                .leadingAnchor
                .constraint(equalTo: productImageView.trailingAnchor,
                            constant: 10)
        ])
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        productImageView
            .layer
            .borderColor = UIColor.systemGray2.cgColor
    }

    @objc private func addToBasketButtonHandler(_ sender: Any) {
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
