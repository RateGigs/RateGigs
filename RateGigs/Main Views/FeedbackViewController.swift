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
    var newRating : Double = 0.0
    
    var artistName = ""
    var artist = false
    var thisRating : Double = 0.0
    
    @IBOutlet weak var bodyView: UITextView!
    var rawTalentRating : Double = 0.0
    var setListRating : Double = 0.0
    var crowdEngagementRating : Double = 0.0
    var productionRating : Double = 0.0
    var overallPerformanceRating : Double = 0.0
    var username = ""
    var rateType = ""
    var headerImage = UIImage()

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        print(overallPerformanceRating)
    }

    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = artistName
        headerImageView.image = headerImage
        
        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                print(postDict)
                
            }) { (error) in
                print(error.localizedDescription)
        }
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

    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Write your review..."){
            textView.text = ""
        }
    }

    @IBAction func submit(_ sender: Any) {
        if(artist){
            let alert = UIAlertController(title: "Location", message: "Please enter the venue/location you saw this artist perform.", preferredStyle:
                UIAlertControllerStyle.alert)

            alert.addTextField(configurationHandler: textFieldHandler)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in

                let textField = alert.textFields![0] as UITextField

                self.writeData(location: textField.text!)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            }))

            self.present(alert, animated: true, completion:nil)
        }else{
            let alert = UIAlertController(title: "Location", message: "Please enter the location you attended this venue.", preferredStyle:
                UIAlertControllerStyle.alert)

            alert.addTextField(configurationHandler: textFieldHandler)

            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in

                let textField = alert.textFields![0] as UITextField

                self.writeData(location: textField.text!)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            }))

            self.present(alert, animated: true, completion:nil)
        }
    }

    func textFieldHandler(textField: UITextField!)
    {
    }

    func writeData(location: String){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .none

        let dateString = formatter.string(from: date)

        if(!checkBody()){
            self.ratingsCount += 1

            let ud = UUID().uuidString
            var path = ""
            if(artist){
                path = "Artists"
            }else{
                path = "Venues"
            }

            if(rateType == "simple"){
                let rateDict = ["overall_rating": overallPerformanceRating,
                                "rateBody" : bodyView.text,
                                "username" : username,
                                "artistID" : artistID,
                                "artistName" : artistName,
                                "location" : location,
                                "date" : dateString,
                                "timeStamp" : NSDate().timeIntervalSince1970,
                                "ratingType" : 0] as [String : Any]

                ref.child(path)
                    .child(artistID)
                    .child("Ratings")
                    .child(ud)
                    .updateChildValues(rateDict)

                self.ref.child("users")
                    .child((Auth.auth().currentUser?.uid)!)
                    .child("Ratings")
                    .child(path)
                    .child(ud)
                    .updateChildValues(rateDict)
            }else{
                let rateDict = ["overall_rating": overallPerformanceRating,
                                "raw_talent" : rawTalentRating,
                                "set_list" : setListRating,
                                "crowd_engagement" : crowdEngagementRating,
                                "production" : productionRating,
                                "rateBody" : bodyView.text,
                                "username" : username,
                                "date" : dateString,
                                "location" : location,
                                "timeStamp" : NSDate().timeIntervalSince1970,
                                "artistID" : artistID,
                                "artistName" : artistName,
                                "ratingType" : 1] as [String : Any]
                ref.child(path)
                    .child(artistID)
                    .child("Ratings")
                    .child(ud)
                    .updateChildValues(rateDict)

                self.ref.child("users")
                    .child((Auth.auth().currentUser?.uid)!)
                    .child("Ratings")
                    .child(path)
                    .child(ud)
                    .updateChildValues(rateDict)
            }

            self.ref.child(path)
                .child(self.artistID)
                .updateChildValues(["ratings_count": self.ratingsCount])

            self.ref.child(path)
                .child(self.artistID)
                .updateChildValues(["adjusted_rating": self.newRating / Double(self.ratingsCount)])



            self.ref.child(path)
                .child(self.artistID)
                .updateChildValues(["overall_rating": self.newRating])

            let viewControllers = self.navigationController!.viewControllers as [UIViewController]
            for vc:UIViewController in viewControllers {
                if vc.isKind(of: ArtistViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }else{
            let alertController = UIAlertController(title: "Oops!", message:
                "Make sure to leave a sweet review of your experiences!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Gotcha", style: UIAlertActionStyle.default,handler: nil))

            self.present(alertController, animated: true, completion: nil)
        }
    }

    func checkBody() -> Bool{
       return bodyView.text == ""
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
