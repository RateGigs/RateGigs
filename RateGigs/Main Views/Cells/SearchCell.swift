//
//  SearchCell.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/10/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet var artistImage: UIImageView!
    @IBOutlet var subText: UILabel!
    @IBOutlet var mainText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
