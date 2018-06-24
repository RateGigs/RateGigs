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
        if(emailField.text != "" && passwordField.text != "" && isValid(emailField.text!)){
            performSegue(withIdentifier: "next", sender: nil)
        }else{
            alert()
        }
    }

    func alert(){
        let alertController = UIAlertController(title: "Oops!", message:
            "Make sure all fields are filled in, and a valid email is used.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Gotcha", style: UIAlertActionStyle.default,handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : CriticalViewController = segue.destination as! CriticalViewController
        user.email = emailField.text!
        user.password = passwordField.text!
        
        vc.user = user
    }
}
