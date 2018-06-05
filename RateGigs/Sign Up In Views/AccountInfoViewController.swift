//
//  AccountInfoViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/11/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit

class AccountInfoViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    var user = User()
    
    override func viewWillAppear(_ animated: Bool) {
        nextButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = false    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        textField.resignFirstResponder()  //if desired
        return true
    }
    
    @IBAction func next(_ sender: Any) {
        //UPDATE THIS LATER ON TO BE MORE INTUITIVE
        if(emailField.text != "" && passwordField.text != ""){
            performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : CriticalViewController = segue.destination as! CriticalViewController
        user.email = emailField.text!
        user.password = passwordField.text!
        
        vc.user = user
    }
}
