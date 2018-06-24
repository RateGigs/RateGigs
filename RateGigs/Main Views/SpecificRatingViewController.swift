//
//  SpecificRatingViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/9/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase

class SpecificRatingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    var artistName = ""
    var ratingID = ""
    var artistID = ""
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ratingCircle: UIImageView!
    var artist = false
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingsCollection: UICollectionView!
    var curRating : Rating!
    var ratingType = 0
    var ref = DatabaseReference()
    
    var overallRating = 0.0
    var username = ""
    var body = ""
    var production = 0.0
    var crowdEngagement = 0.0
    var rawTalent = 0.0
    var setList = 0.0
    
    var ratingTypes = ["Overall Rating", "Production", "Crowd Engagement", "Raw Talent", "Set List"]
    var ratingValues = [0.0, 0.0, 0.0, 0.0, 0.0]
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet var soundwave: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = artistName
        
        overallRating = curRating.overall_rating
        username = curRating.username
        body = curRating.body
        production = curRating.production
        crowdEngagement = curRating.crowd_engagement
        rawTalent = curRating.raw_talent
        setList = curRating.set_list
        ratingType = curRating.ratingType
        
        loadArtist()
        
        usernameLabel.text = username
        bodyView.text = body
        ref = Database.database().reference()
        
        self.soundwave.image = UIImage(named: (overallRating.round(nearest: 1) * 10).description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadArtist(){
        ratingValues[0] = overallRating
        ratingValues[1] = production
        ratingValues[2] = crowdEngagement
        ratingValues[3] = rawTalent
        ratingValues[4] = setList
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SpecificRatingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpecificRatingCollectionViewCell
        
        cell.ratingTypeLabel.text = ratingTypes[indexPath.row]

        if(ratingType == 0){
            switch indexPath.row {
                case 0:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(overallRating)).description)
                case 1:
                    cell.ratingValueImage.image = UIImage(named: "na")
                case 2:
                    cell.ratingValueImage.image = UIImage(named: "na")
                case 3:
                    cell.ratingValueImage.image = UIImage(named: "na")
                case 4:
                    cell.ratingValueImage.image = UIImage(named: "na")
                default:
                    cell.ratingValueImage.image = UIImage(named: "na")
            }
        }else{
            switch indexPath.row {
                case 0:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(overallRating)).description)
                case 1:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(production)).description)
                case 2:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(crowdEngagement)).description)
                case 3:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(rawTalent)).description)
                case 4:
                    cell.ratingValueImage.image = UIImage(named: "r_" + (Int(setList)).description)
                default:
                    cell.ratingValueImage.image = UIImage(named: "r_0")
            }
        }
        return cell
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
