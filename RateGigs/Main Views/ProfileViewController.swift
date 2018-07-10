//
//  ProfileViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/11/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var venueCollectionView: UICollectionView!
    @IBOutlet var artistsCollectionView: UICollectionView!
    var titles = ["Faster Horses", "Luke Bryan", "Blackbear"]
    var ref = DatabaseReference()

    @IBOutlet weak var reviewStatusLabel: UILabel!
    var reviewsCount = 0

    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet var venueCountLabel: UILabel!
    @IBOutlet var artistCountLabel: UILabel!
    
    var artistRatingNames = [String]()
    var artistRatingIDs = [String]()
    var artistRatingKeys = [String]()
    
    var venueRatingKeys = [String]()
    var venueRatingNames = [String]()
    var venuetRatingIDs = [String]()

    var artistRatings = [Rating]()
    var venueRatings = [Rating]()

    var selectedArtistID = ""
    var selectedArtistKey = ""
    var selectedArtistName = ""
    var selectedRating: Rating!

    var images = [String:UIImage]()
    @IBOutlet weak var topRatedOne: UILabel!
    @IBOutlet weak var topRatedTwo: UILabel!
    @IBOutlet weak var topRatedOneImage: UIImageView!
    @IBOutlet weak var topRatedTwoImage: UIImageView!

    enum RatingType {
        case artist
        case venue
    }

    var ratingObject : RatingType!

    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        reviewsCount = 0
        loadUserInfo()
        loadVenueReviews()
        loadArtistReviews()
        loadImages()
        loadTopRated()
    }

    func loadImages(){
        print("LoadImages:")
        let methodStart = Date()

        ref.child("images")
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in

                for imageData in snapshot.children.allObjects as! [DataSnapshot] {
                    let url = URL(string: imageData.value as! String)

                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)

                    //Add the loaded image to the array
                    self.images[imageData.key] = image
                    self.artistsCollectionView.reloadData()
                    self.venueCollectionView.reloadData()
                }


            }) { (error) in
                print(error.localizedDescription)
        }

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }

    func checkReviewStatus(){
        if(reviewsCount < 10){
            reviewStatusLabel.text = "Beginner Rater"
        }else if(reviewsCount < 20){
            reviewStatusLabel.text = "Rater In Training"
        }else if(reviewsCount < 50){
            reviewStatusLabel.text = "Genius Rater"
        }else if(reviewsCount < 100){
            reviewStatusLabel.text = "Sensei Rater"
        }else{
            reviewStatusLabel.text = "Rating Master"
        }
    }

    func loadUserInfo(){
        print("LoadUserInfo:")
        let methodStart = Date()

        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                let username = postDict["username"]
                self.usernameLabel.text = username as? String
            
            }) { (error) in
                print(error.localizedDescription)
            }

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }
    
    func loadArtistReviews(){
        print("LoadArtistReviews:")
        let methodStart = Date()

        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .child("Ratings")
            .child("Artists")
            .observe(.childAdded, with: { snapshot in
                self.reviewsCount += 1
                self.reviewsCountLabel.text = "\(self.reviewsCount.description) Reviews"

                self.checkReviewStatus()
                self.artistRatingKeys.append(snapshot.key)
                

                let postDict = snapshot.value as? [String : Any] ?? [:]
                let artistName: String = postDict["artistName"] as! String
                let artistID = postDict["artistID"]

                self.artistRatingIDs.append(artistID as! String)
                self.artistRatingNames.append(artistName)

                self.artistCountLabel.text = "ARTISTS (" + self.artistRatingNames.count.description + ")"
                self.artistsCollectionView.reloadData()

                let value = snapshot.value as? NSDictionary

                let ratingType : Double = (value?["ratingType"] as? Double)!
                print("Rating Type: \(ratingType)")
                let overallRating : Double = (value?["overall_rating"] as? Double)!
                let username : String = (value?["username"] as? String)!
                let body : String = (value?["rateBody"] as? String)!
                let name : String = (value?["artistName"] as? String)!
                let location : String = (value?["location"] as? String)!
                let date : String = (value?["date"] as? String)!
                var production = 0.0
                var crowdEngagement = 0.0
                var rawTalent = 0.0
                var setList = 0.0

                //In depth Rating
                if(ratingType == 1.0){
                    production = (value?["production"] as? Double)!
                    crowdEngagement = (value?["crowd_engagement"] as? Double)!

                    rawTalent = (value?["raw_talent"] as? Double)!
                    setList = (value?["set_list"] as? Double)!
                }

                let newRating = Rating(ratingType: Int(ratingType), setList: setList, rawTalent: rawTalent, production: production, crowdEngagement: crowdEngagement, overallRating: overallRating, username: username, body: body,  location: location, date: date)
                newRating.artistName = name

                self.artistRatings.append(newRating)
            }) { (error) in
                print(error.localizedDescription)
        }

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }
    
    func loadVenueReviews(){
        print("LoadVenueReviews:")
        let methodStart = Date()

        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .child("Ratings")
            .child("Venues")
            .observe(.childAdded, with: { snapshot in
                self.reviewsCount += 1
                self.reviewsCountLabel.text = "\(self.reviewsCount.description) Reviews"

                self.checkReviewStatus()
                self.venueRatingKeys.append(snapshot.key)
                
                let postDict = snapshot.value as? [String : Any] ?? [:]
                let artistName: String = postDict["artistName"] as! String
                let artistID = postDict["artistID"]

                self.venuetRatingIDs.append(artistID as! String)
                self.venueRatingNames.append(artistName)
                
                self.venueCountLabel.text = "VENUES (" + self.venueRatingNames.count.description + ")"
                self.venueCollectionView.reloadData()

                let value = snapshot.value as? NSDictionary

                let ratingType : Double = (value?["ratingType"] as? Double)!
                print("Rating Type: \(ratingType)")
                let overallRating : Double = (value?["overall_rating"] as? Double)!
                let username : String = (value?["username"] as? String)!
                let body : String = (value?["rateBody"] as? String)!
                let name : String = (value?["artistName"] as? String)!
                let location : String = (value?["location"] as? String)!
                let date : String = (value?["date"] as? String)!
                var production = 0.0
                var crowdEngagement = 0.0
                var rawTalent = 0.0
                var setList = 0.0

                //In depth Rating
                if(ratingType == 1.0){
                    production = (value?["production"] as? Double)!
                    crowdEngagement = (value?["crowd_engagement"] as? Double)!

                    rawTalent = (value?["raw_talent"] as? Double)!
                    setList = (value?["set_list"] as? Double)!
                }

                let newRating = Rating(ratingType: Int(ratingType), setList: setList, rawTalent: rawTalent, production: production, crowdEngagement: crowdEngagement, overallRating: overallRating, username: username, body: body,  location: location, date: date)
                newRating.artistName = name

                self.venueRatings.append(newRating)
            }) { (error) in
                print(error.localizedDescription)
        }

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            if(artistRatingNames.count > 9){
                return 9
            }
            return artistRatingNames.count
        }else{
            if(venueRatingNames.count > 9){
                return 9
            }
            return venueRatingNames.count
        }
    }

    func loadTopRated(){
        print("LoadTopRated:")
        let methodStart = Date()

        topRatedTwo.adjustsFontSizeToFitWidth = true
        topRatedOne.adjustsFontSizeToFitWidth = true
        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("Ratings").child("Artists")
            .queryOrdered(byChild: "overall_rating").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) -> Void in
                let postDict = snapshot.value as? [String : Any] ?? [:]

                let artistName : String = postDict["artistName"] as! String

                self.topRatedOne.text = artistName
                
               // self.topRatedOneImage.image = self.images[snapshot.key]
            })

        ref.child("users").child((Auth.auth().currentUser?.uid)!).child("Ratings").child("Venues")
            .queryOrdered(byChild: "overall_rating").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) -> Void in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                let artistName : String = postDict["artistName"] as! String

                self.topRatedTwo.text = artistName
             //   self.topRatedTwoImage.image = self.images[snapshot.key]
            })

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if(collectionView.tag == 0){
            if(indexPath.row == 8){
                ratingObject = .artist
                performSegue(withIdentifier: "more", sender: nil)
            }else{
                
                if(indexPath.section == 0){
                    
                    print(artistRatingKeys[indexPath.row])
                    selectedArtistID = artistRatingIDs[indexPath.row]
                    selectedArtistKey = artistRatingKeys[indexPath.row]
                    selectedArtistName = artistRatingNames[indexPath.row]
                    selectedRating = artistRatings[indexPath.row]
                    performSegue(withIdentifier: "showRating", sender: nil)
                }else{
                    
                }
            }
        }else{
            if(indexPath.row == 8){
                ratingObject = .venue
                performSegue(withIdentifier: "more", sender: nil)
            }else{
                
                if(indexPath.section == 0){
                    print(artistRatingKeys[indexPath.row])
                    selectedArtistID = venuetRatingIDs[indexPath.row]
                    selectedArtistKey = venueRatingKeys[indexPath.row]
                    selectedArtistName = venueRatingNames[indexPath.row]
                    selectedRating = venueRatings[indexPath.row]
                    performSegue(withIdentifier: "showRating", sender: nil)

                }else{
                    
                }
            }
        }
        
    }
    
    func loadRating(id: String){
        print("LoadTopRated:")
        let methodStart = Date()

        ref.child("Artists").child(selectedArtistKey).child("Ratings").child(id).observeSingleEvent(of: .childAdded, with: { snapshot in
            
            if(snapshot.exists()){
                let value = snapshot.value as? NSDictionary
                let ratingType : Double = (value?["overall_rating"] as? Double)!
                
                let overallRating : Double = (value?["overall_rating"] as? Double)!
                let username : String = (value?["username"] as? String)!
                let body : String = (value?["rateBody"] as? String)!
                let location : String = (value?["location"] as? String)!
                let date : String = (value?["date"] as? String)!
                var production = 0.0
                var crowdEngagement = 0.0
                var rawTalent = 0.0
                var setList = 0.0
                
                //In depth Rating
                if(ratingType == 1.0){
                    production = (value?["overall_rating"] as? Double)!
                    crowdEngagement = (value?["overall_rating"] as? Double)!
                    
                    rawTalent = (value?["overall_rating"] as? Double)!
                    setList = (value?["overall_rating"] as? Double)!
                }
                
                self.selectedRating = Rating(ratingType: Int(ratingType), setList: setList, rawTalent: rawTalent, production: production, crowdEngagement: crowdEngagement, overallRating: overallRating, username: username, body: body, location: location, date: date)
                
                self.performSegue(withIdentifier: "showRating", sender: nil)
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }

        let methodFinish = Date()
        let executionTime = methodFinish.timeIntervalSince(methodStart)
        print("Execution time: \(executionTime)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row < 8){
            if(collectionView.tag == 0){
                let cell : HomeCollectionViewCell = artistsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
                cell.textLabel.text = artistRatingNames[indexPath.row]
                cell.image.image = images[artistRatingIDs[indexPath.row]]
                return cell
            }else{
                let cell : HomeCollectionViewCell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
                cell.textLabel.text = venueRatingNames[indexPath.row]
                switch(cell.textLabel.text?.lowercased()){
                case "mo pop":
                    cell.image.image = UIImage(named: "mopop")
                    break
                case "prime":
                    cell.image.image = UIImage(named: "prime")
                    break
                case "common ground":
                    cell.image.image = UIImage(named: "commonground")
                    break
                case "breakaway":
                    cell.image.image = UIImage(named: "breakaway")
                    break
                case "wayside central":
                    cell.image.image = UIImage(named: "wayside")
                    break
                case "20 monroe live":
                    cell.image.image = UIImage(named: "20monroe")
                    break
                case "lollapalooza":
                    cell.image.image = UIImage(named: "lollapalooza")
                    break
                case "masonic temple":
                    cell.image.image = UIImage(named: "masonictemple")
                    break
                default:
                    break
                }
                return cell
            }
        
            
        }else{
            if(collectionView.tag == 0){
                let cell = artistsCollectionView.dequeueReusableCell(withReuseIdentifier: "more", for: indexPath) as! HomeCollectionViewCell
            
                cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell
            }else{
                let cell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: "more", for: indexPath) as! HomeCollectionViewCell

                cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showRating"){
            let vc : SpecificRatingViewController = segue.destination as! SpecificRatingViewController
            
            vc.artistID = selectedArtistID
            vc.ratingID = selectedArtistKey
            vc.artistName = self.selectedArtistName
            vc.curRating = self.selectedRating
        }else if (segue.identifier == "more") {
            let vc : MyRatingsTableViewController = segue.destination as! MyRatingsTableViewController

            if(ratingObject == .artist){
                vc.ratingObject = .artist

            }else{
                vc.ratingObject = .venue

            }
        }
    }
}
