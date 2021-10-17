//
//  ProductInfoView.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit
import SwiftUI

class ProductInfoView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        label.textColor = .label
        label.text = "Характеристики"
        return label
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = defaultNumberOfLines
        label.textColor = .label
        return label
    }()

    private var isExpanded = false
    private var defaultNumberOfLines = 5

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.setupView()
    }

    func configure(description: String) {
        descriptionLabel.text = description
    }

    // MARK: - Private methods
    private func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedEvent(tapGestureRecognizer:)))
        self.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            titleLabel
                .topAnchor
                .constraint(equalTo: self.topAnchor,
                            constant: 10),
            titleLabel
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10),
            titleLabel
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 10),
            titleLabel
                .bottomAnchor
                .constraint(equalTo: descriptionLabel.topAnchor,
                            constant: -10),

            descriptionLabel
                .leadingAnchor
                .constraint(equalTo: self.leadingAnchor,
                            constant: 15),
            descriptionLabel
                .trailingAnchor
                .constraint(equalTo: self.trailingAnchor,
                            constant: -10),
            descriptionLabel
                .bottomAnchor
                .constraint(equalTo: self.bottomAnchor,
                            constant: -10)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @objc private func tappedEvent(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.isExpanded {
            self.isExpanded = false
            descriptionLabel.numberOfLines = defaultNumberOfLines
        } else {
            self.isExpanded = true
            descriptionLabel.numberOfLines = 0
        }
    }
}

struct ProductInfoView_Preview: PreviewProvider {
    static var previews: some View {
        let view = ProductInfoView()
        view.descriptionLabel.text = """
The Official Street League Skateboarding Mobile Game.

#1 game in 80 countries. Loved by skaters all over the world.


Touch Arcade review – 4.5/5 – “”True skate is clearly something special””


Note: True Skate comes with a single skate park and contains additional content only available by In-App purchase. See below.
"""
        return UIPreviewView(view)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 375, height: 200))
    }
}
