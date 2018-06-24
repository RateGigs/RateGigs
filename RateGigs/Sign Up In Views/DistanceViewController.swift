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
    var checked = false
    @IBOutlet var checkImage: UIButton!
    var user = User()
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet var slider: UISlider!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        if(!checked){
            distanceLabel.text = "\(slider.value.rounded())"
        }
    }

    @IBAction func checkMarkClicked(_ sender: Any) {
        checked = !checked
        print(checked)
        if(checked){
            checkImage.setImage(#imageLiteral(resourceName: "ic_check_box_white"), for: .normal)
            distanceLabel.text = "Let's Jam!"
        }else{
            checkImage.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank_white"), for: .normal)
            distanceLabel.text = "\(slider.value.rounded())"
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if(checked){
            user.distance = 1000000
        }else{
            user.distance = Int(slider.value)
        }

        performSegue(withIdentifier: "next", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : UsernameViewController = segue.destination as! UsernameViewController
        
        vc.userInfo = user
    }
}
