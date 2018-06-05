//
//  ReviewCell.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/11/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
