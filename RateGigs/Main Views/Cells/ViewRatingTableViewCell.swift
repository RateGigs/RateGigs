//
//  ViewRatingTableViewCell.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/9/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit

class ViewRatingTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingTextLabel: UILabel!
    @IBOutlet var ratingValueLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
