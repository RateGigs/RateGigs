//
//  Rating.swift
//  RateGigs
//
//  Created by BryanA Caragay on 6/7/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import Foundation

class Rating {

    var crowd_engagement = 0.0
    var overall_rating = 0.0
    var production = 0.0
    var ratingType = 0
    var raw_talent = 0.0
    var set_list = 0.0
    var username = ""
    var body = ""
    var artistName = ""
    
    init(ratingType: Int, setList: Double, rawTalent: Double, production: Double, crowdEngagement:Double, overallRating: Double, username: String, body: String) {
        self.ratingType = ratingType
        self.set_list = setList
        self.raw_talent = rawTalent
        self.production = production
        self.crowd_engagement = crowdEngagement
        self.username = username
        self.body = body
        self.overall_rating = overallRating
    }
    
    func toString() -> String{
        return "Name: \(artistName), Raw Talent: \(raw_talent), Overall Rating: \(overall_rating), Production: \(production), Set List: \(set_list)"
    }
}
