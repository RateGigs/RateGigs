//
//  SignInViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/11/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON
import Foundation
import JWT
import RNCryptor
import Cider

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        signupButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loginButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func encryptMessage(message: String, encryptionKey: String) -> Data {
        //let data: NSData = ...
//        let password = "Secret password"
//        let ciphertext = RNCryptor.encrypt(data: data, withPassword: password)
        
        let messageData = message.data(using: .utf8)!
        let cipherData = RNCryptor.encrypt(data: messageData, withPassword: encryptionKey)
        return cipherData
    }
    
    func decrypt(encryptedText : String, password: String) -> String {
        do  {
            let data: Data = Data(base64Encoded: encryptedText)! // Just get data from encrypted base64Encoded string.
            let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
            let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
            return decryptedString ?? ""
        }
        catch {
            return "FAILED"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
             self.performSegue(withIdentifier: "login", sender: nil)
        } else {
            //User Not logged in
        }
        
    }
    
    @IBAction func logIn(_ sender: Any) {
       

        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
           
            if(error == nil){
                //Log in success.
                 self.performSegue(withIdentifier: "login", sender: nil)
            }else{
                //Error logging in.
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
