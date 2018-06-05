//
//  DistanceViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 2/10/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit

class DistanceViewController: UIViewController {

    var email = ""
    var password = ""
    
    var user = User()
    
    @IBOutlet var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func next(_ sender: Any) {
        user.distance = Int(slider.value)
        performSegue(withIdentifier: "next", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : UsernameViewController = segue.destination as! UsernameViewController
        
        vc.userInfo = user
    }
}
