//
//  PaymentView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 13.10.2021.
//

import UIKit
import SwiftUI

class PaymentView: UIView {

    // MARK: - Public properties
    weak var basketDelegate: BasketViewControllerDelegate?

    // MARK: - Subviews
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Total: "
        return label
    }()

    private(set) lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            textLabel,
            priceLabel
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 5
        stack.alignment = .fill
        stack.contentMode = .scaleToFill
        return stack
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "rublesign.circle.fill"),
                        for: .normal)
        button.addTarget(self,
                         action: #selector(payButtonHandler(_:)),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.setupView()
    }

    // MARK: - Public methods
    func setTotalPrice(price value: Int) {
        priceLabel.text = ConvertPriceToString(price: value)
    }

    // MARK: - Private methods
    private func setupView() {
        self.addSubview(priceStackView)
        self.addSubview(payButton)

        NSLayoutConstraint.activate([
            priceStackView
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 10),
            priceStackView
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10),
            priceStackView
                .bottomAnchor
                .constraint(equalTo: payButton.topAnchor,
                            constant: -5),
            priceStackView
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),

            payButton
                .centerXAnchor
                .constraint(equalTo: self.centerXAnchor),
            payButton
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor)
        ])
    }

    @objc private func payButtonHandler(_ sender: Any) {
        basketDelegate?.makePayment()
    }
}

struct PaymentView_Preview: PreviewProvider {
    static var previews: some View {
        let view = PaymentView()
        view.priceLabel.text = ConvertPriceToString(price: 45000)
        return UIPreviewView(view)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 150))
    }
}
