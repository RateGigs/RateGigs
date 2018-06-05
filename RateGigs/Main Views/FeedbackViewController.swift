//
//  FeedbackViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/24/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase

class FeedbackViewController: UIViewController, UITextViewDelegate{

    var ref = DatabaseReference()
    var artistID = ""
    var ratingsCount = 0
    var newRating = 0.0
    
    var artistName = ""
    var artist = false
    var thisRating = 0.0
    
    var rawTalentRating = 0.0
    var setListRating = 0.0
    var crowdEngagementRating = 0.0
    var productionRating = 0.0
    var overallPerformaceRating = 0.0
    
    var rateType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       
        self.view.endEditing(true)
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(_ sender: Any) {
        self.ratingsCount += 1
        
        var ud = UUID().uuidString
        var path = ""
        if(artist){
            path = "Artists"
        }else{
            path = "Venues"
        }
        
        if(rateType == "simple"){
            let rateDict = ["overall_rating": overallPerformaceRating,
                            "ratingType" : 1]
            
            ref.child(path)
                .child(artistID)
                .child("Ratings")
                .child(ud)
                .updateChildValues(rateDict)
        }else{
            let rateDict = ["overall_rating": overallPerformaceRating,
                            "raw_talent" : rawTalentRating,
                            "set_list" : setListRating,
                            "crowd_engagement" : crowdEngagementRating,
                            "production" : productionRating,
                            "ratingType" : 1]
            ref.child(path)
                .child(artistID)
                .child("Ratings")
                .child(ud)
                .updateChildValues(rateDict)
        }
        
        self.ref.child(path)
            .child(self.artistID)
            .updateChildValues(["ratings_count": self.ratingsCount])
        
        self.ref.child(path)
            .child(self.artistID)
            .updateChildValues(["adjusted_rating": self.newRating / Double(self.ratingsCount)])
        
        self.ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .child("Ratings")
            .child(path)
            .child(ud)
            .updateChildValues([artistName : artistID])
        
        self.ref.child(path)
            .child(self.artistID)
            .updateChildValues(["overall_rating": self.newRating])
    
        let viewControllers = self.navigationController!.viewControllers as [UIViewController]
        for vc:UIViewController in viewControllers {
            if vc.isKind(of: ArtistViewController.self) {
                _ = self.navigationController?.popToViewController(vc, animated: true)
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
