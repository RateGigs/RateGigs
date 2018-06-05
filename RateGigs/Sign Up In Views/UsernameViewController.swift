//
//  UsernameViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/11/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UsernameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var finishButton: UIButton!
    var email = ""
    var password = ""
    var checked = false
    @IBOutlet var checkImage: UIButton!
    @IBOutlet var usernameField: UITextField!
    var userInfo = User()
    
    var ref = DatabaseReference()
    
    override func viewWillAppear(_ animated: Bool) {
        finishButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ref = Database.database().reference()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func checkMarkClicked(_ sender: Any) {
        checked = !checked
        print(checked)
        if(checked){
            checkImage.setImage(#imageLiteral(resourceName: "ic_check_box_white"), for: .normal)
        }else{
            checkImage.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank_white"), for: .normal)
        }
    }
    
    @IBAction func finish(_ sender: Any) {
        userInfo.username = usernameField.text!
        
        Auth.auth().createUser(withEmail: userInfo.email, password: userInfo.password) { (user, error) in
            if(error == nil){
                self.ref.child("users")
                .child((user?.uid)!)
                .updateChildValues(["email" : self.userInfo.email,
                                    "username": self.userInfo.username,
                                    "distance": self.userInfo.distance,
                                    "important": self.userInfo.importantFactor])
                
                self.ref.child("users")
                    .child((user?.uid)!)
                    .child("artists")
                    .updateChildValues(["artist_1": self.userInfo.artists[0],
                                        "artist_2": self.userInfo.artists[1],
                                        "artist_3": self.userInfo.artists[2]])
                
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                print(error)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
