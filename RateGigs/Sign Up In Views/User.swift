//
//  User.swift
//  RateGigs
//
//  Created by Bryan Caragay on 2/10/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import Foundation

class User{
    var username = ""
    var password = ""
    var email = ""
    var importantFactor = ""
    var artists = [String]()
    var distance = 0
    
    init() {

    }
    
    func toString(){
        print(username)
        print(password)
        print(email)
        print(importantFactor)
        print(distance)
        for i in 0...artists.count - 1 {
            print(artists[i])
        }
    }
}
