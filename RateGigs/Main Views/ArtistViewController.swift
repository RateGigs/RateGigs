//
//  ArtistViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 2/5/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ArtistViewController: UIViewController {

    var artistName = ""
    var ratingType = ""
    var artistID = ""
    var currentRating = 0.0
    var ratingsCount = 0
    var currentOverallRating = 0.0
    var artist = false
    
    @IBOutlet var soundwave: UIImageView!
    var ref = DatabaseReference()
    
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var rateButton: UIButton!
    @IBOutlet var viewRatingsButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        ref = Database.database().reference()
        
        titleLabel.text = artistName
        rateButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewRatingsButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(artist){
            ref.child("Artists").child(artistID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if(snapshot.exists()){
                        let value = snapshot.value as? NSDictionary
                        let ratingString = value?["adjusted_rating"] as? Double
                    let overallRatingString = value?["overall_rating"] as? Double
                    
                    if let ratingsCount = value?["ratings_count"] as? Int{
                        self.ratingsCount = ratingsCount
                    }else{
                        self.ratingsCount = 0
                    }
                        let num: Double = Double(ratingString!)
                           // Returns 4.5
                     let overallRating: Double = Double(overallRatingString!)
                    self.soundwave.image = UIImage(named: (num.round(nearest: 1) * 10).description)
                    self.ratingLabel.text =  num.round(nearest: 0.1).description
                    self.currentRating = overallRating
                }else{
                    self.ref
                        .child("Artists")
                        .child(self.artistID)
                        .setValue(["name":              self.artistName,
                                   "overall_rating":    0,
                                   "adjusted_rating":   0,
                                   "ratings_count":     0])
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }else{
            ref.child("Venues").child(artistID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if(snapshot.exists()){
                    let value = snapshot.value as? NSDictionary
                    let ratingString = value?["adjusted_rating"] as? Double
                    let overallRatingString = value?["overall_rating"] as? Double
                    
                    if let ratingsCount = value?["ratings_count"] as? Int{
                        self.ratingsCount = ratingsCount
                    }else{
                        self.ratingsCount = 0
                    }
                    let num: Double = Double(ratingString!)
                    // Returns 4.5
                    let overallRating: Double = Double(overallRatingString!)
                    self.soundwave.image = UIImage(named: (num.round(nearest: 1) * 10).description)
                    self.ratingLabel.text =  num.round(nearest: 0.1).description
                    self.currentRating = overallRating
                }else{
                    self.ref
                        .child("Venues")
                        .child(self.artistID)
                        .setValue(["name":              self.artistName,
                                   "overall_rating":    0,
                                   "adjusted_rating":   0,
                                   "ratings_count":     0])
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func fastRating(_ sender: Any) {
        
        let alert = UIAlertController(title: "Login to Festival Rating", message: "Please enter your administrator code below.", preferredStyle:
            UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: textFieldHandler)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            
            let textField = alert.textFields![0] as UITextField
            if(textField.text == "0000"){
                self.ratingType = "fast"
                self.performSegue(withIdentifier: "rate", sender: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion:nil)
       
    }
    
    func textFieldHandler(textField: UITextField!)
    {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ViewRatings(_ sender: Any) {
        self.performSegue(withIdentifier: "viewRatings", sender: nil)
    }
    
    @IBAction func rate(_ sender: Any) {
        let alert = UIAlertController(title: "Which type of rating would you like to give?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Simple", style: .default, handler: { action in
            self.ratingType = "simple"
            self.performSegue(withIdentifier: "rate", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "In-Depth", style: .default, handler: { action in
            self.ratingType = "indepth"
            self.performSegue(withIdentifier: "rate", sender: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rate"){
            let vc : RateViewController = segue.destination as! RateViewController
            
            vc.artist = self.artist
            vc.id = artistID
            vc.currentRating = self.currentRating
            vc.artistName = self.artistName
            vc.ratingsCount = self.ratingsCount
            vc.rateType = self.ratingType
        }else{
            let vc : PageInfoViewController = segue.destination as! PageInfoViewController
            vc.artistName = self.artistName
        }
    }
 

}

extension Double {
    func round(nearest: Double) -> Double {
        let n = 1/nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
    
    func floor(nearest: Double) -> Double {
        let intDiv = Double(Int(self / nearest))
        return intDiv * nearest
    }
}


