//
//  ReviewTableViewCell.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 07.10.2021.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.text = nil
        reviewTextLabel.text = nil
    }
    
    func configure(review: Review) {
        self.usernameLabel.text = "User"
        self.reviewTextLabel.text = review.text
    }
}
