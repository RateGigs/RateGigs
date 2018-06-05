//
//  Artist.swift
//  RateGigs
//
//  Created by Bryan Caragay on 3/14/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import Foundation
import UIKit

class Artist {
    var image: UIImage
    var name: String
    var id: String
    
    init() {
        image = UIImage()
        name = ""
        id = ""
    }
    
    func setID(id: String){
        self.id = id
    }
    
    func setImage(image: UIImage){
        self.image = image
    }
    
    func setName(name: String){
        self.name = name
    }

}
