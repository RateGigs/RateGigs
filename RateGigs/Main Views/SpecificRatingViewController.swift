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
    //0 = simple, 1 = in depth
    var ratingType = 0
    var ref = DatabaseReference()
    
    var ratingTypes = ["Crowd Involvement", "Raw Talent", "Something", "Something", "Something"]
    
    @IBOutlet var soundwave: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = artistName
        
        ref = Database.database().reference()
        loadArtist()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadArtist(){
        ref.child("Artists").child(artistID).child("Ratings")
            .child(ratingID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if(snapshot.exists()){
                let value = snapshot.value as? NSDictionary
                let overallRatingString = value?["overall_rating"] as? Double
                self.ratingType = (value?["ratingType"] as? Int)!
                self.ratingLabel.text = Int((overallRatingString)!).description
                
                if(self.ratingType == 0){
                    self.ratingLabel.isHidden = false
                    self.ratingCircle.isHidden = false
                    self.ratingsCollection.isHidden = true
                }
                
                let overallRating: Double = Double(overallRatingString!)
                self.soundwave.image = UIImage(named: (overallRating.round(nearest: 1) * 10).description)
              //  self.ratingLabel.text =  num.round(nearest: 0.1).description
              //  self.currentRating = overallRating
            }
                self.ratingsCollection.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if(ratingType == 0){
//            return 0
//        }else{
          return 5
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SpecificRatingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SpecificRatingCollectionViewCell
        
        cell.ratingTypeLabel.text = ratingTypes[indexPath.row]
        
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
