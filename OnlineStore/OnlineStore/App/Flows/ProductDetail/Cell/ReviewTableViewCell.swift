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
        if let userId = review.userId {
            self.usernameLabel.text = "User \(userId)"
        } else {
            self.usernameLabel.text = "Unregistered user"
        }
        
        self.reviewTextLabel.text = review.text
    }
}
