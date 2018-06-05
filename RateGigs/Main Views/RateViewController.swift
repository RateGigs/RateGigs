//
//  RateViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/7/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import FirebaseDatabase
class RateViewController: UIViewController {

    var currentIndex = 0
    var rateType = ""
    var rating = 0.0
    var currentRating = 0.0
    var ratingsCount = 0
    @IBOutlet var rateIcon: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var ratingType: UILabel!
    @IBOutlet var ratingSlider: UISlider!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    var artistName = ""
    var id = ""
    var ratingOptions = ["Raw Talent", "Set List", "Crowd Engagement", "Production", "Overall Performace"]
    var artist = false
    
    var ref = DatabaseReference()
    @IBOutlet var soundwave: UIImageView!
    
    var rawTalentRating = 0.0
    var setListRating = 0.0
    var crowdEngagementRating = 0.0
    var productionRating = 0.0
    var overallPerformaceRating = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
        
        if(rateType == "simple"){
            ratingType.text = "Overall Performace"
        }else if(rateType == "fast"){
            backButton.isHidden = true
        }else{
            backButton.isHidden = false
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        ratingSlider.value = 0
        titleLabel.text = artistName
        ratingSlider.center = soundwave.center
        backButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nextButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func back(_ sender: Any) {
        if(currentIndex > 0){
            currentIndex -= 1
            updateUI()
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if(rateType == "fast"){
            //Used for concerts with RateGigs reps walking around
            fastRating()
        }else if(rateType == "simple"){
            self.performSegue(withIdentifier: "next", sender: nil)
            overallPerformaceRating = Double(ratingSlider.value)
        }else{
            
            if(currentIndex < ratingOptions.count - 1){
                switch(currentIndex){
                case 0:
                    print("setting raw talent")
                    rawTalentRating = Double(ratingSlider.value)
                    break
                case 1:
                    setListRating = Double(ratingSlider.value)
                    break
                case 2:
                    crowdEngagementRating = Double(ratingSlider.value)
                    break
                case 3:
                    productionRating = Double(ratingSlider.value)
                    break
                default:
                    break
                }
                //Continue iterating until options are over
                currentIndex += 1
                updateUI()
            }else{
                print("setting overall")
                overallPerformaceRating = Double(ratingSlider.value)
                self.performSegue(withIdentifier: "next", sender: nil)
            }
        }
    }
    
    func fastRating(){
        if(artist){
        self.ref.child("Artists")
            .child(self.id)
            .updateChildValues(["ratings_count": self.ratingsCount + 1])
        
        self.ref.child("Artists")
            .child(self.id)
            .updateChildValues(["adjusted_rating": (currentRating + rating) / Double(self.ratingsCount + 1)])
        
        self.ref.child("Artists")
            .child(self.id)
            .updateChildValues(["overall_rating": currentRating + rating])
        }else{
            self.ref.child("Venues")
                .child(self.id)
                .updateChildValues(["ratings_count": self.ratingsCount + 1])
            
            self.ref.child("Venues")
                .child(self.id)
                .updateChildValues(["adjusted_rating": (currentRating + rating) / Double(self.ratingsCount + 1)])
            
            self.ref.child("Venues")
                .child(self.id)
                .updateChildValues(["overall_rating": currentRating + rating])
        }
        self.currentRating = currentRating + rating
        self.ratingsCount += 1
        
        ratingSlider.value = 0
        titleLabel.text = artistName
        ratingSlider.center = soundwave.center
        backButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nextButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        soundwave.image = UIImage(named: "0")
        rateIcon.image = UIImage(named: "r_0")
    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        let value = Int(ratingSlider.value) * 10
        print(value.description)
        soundwave.image = UIImage(named: value.description)
        rateIcon.image = UIImage(named: "r_" + (value/10).description)
        rating = Double(value/10)
    }
    
    func updateUI(){
        if(rateType == "simple"){
            ratingSlider.value = 0
            ratingType.text = "Artist"
        }else{
            ratingSlider.value = 0
            ratingType.text = ratingOptions[currentIndex]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "next"){
            let vc : FeedbackViewController = segue.destination as! FeedbackViewController
            print(rating)
            vc.artist = self.artist
            vc.artistName = self.artistName
            vc.ratingsCount = self.ratingsCount
            vc.artistID = self.id
            vc.rateType = self.rateType
            vc.newRating = currentRating + rating
            
            print(currentRating)
            print(rating)
            print(currentRating + rating)
            
            vc.rawTalentRating = self.rawTalentRating
            vc.setListRating = self.setListRating
            vc.crowdEngagementRating = self.crowdEngagementRating
            vc.productionRating = self.productionRating
            vc.overallPerformaceRating = self.overallPerformaceRating
        }
    }
}
