//
//  MyRatingsTableViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 2/6/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase

class Ratingcell : UITableViewCell{
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
}

class MyRatingsTableViewController: UITableViewController {

    var ref = DatabaseReference()
    var ratings = [Rating]()

    var selectedRating : Rating!

    enum RatingType {
        case artist
        case venue
    }

    var ratingObject : RatingType!


    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        loadReviews()
    }

    func loadReviews(){
        if(ratingObject == .artist){
            ref.child("users")
                .child((Auth.auth().currentUser?.uid)!)
                .child("Ratings")
                .child("Artists")
                .observe(.childAdded, with: { snapshot in

                if(snapshot.exists()){
                    let value = snapshot.value as? NSDictionary

                    print(value)

                    let ratingType : Double = (value?["ratingType"] as? Double)!
                    print("Rating Type: \(ratingType)")
                    let overallRating : Double = (value?["overall_rating"] as? Double)!
                    let username : String = (value?["username"] as? String)!
                    let body : String = (value?["rateBody"] as? String)!
                    let artistName : String = (value?["artistName"] as? String)!
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

                    newRating.artistName = artistName

                    print("Adding Rating: " + newRating.toString())
                    self.ratings.append(newRating)
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }else{
            ref.child("users")
                .child((Auth.auth().currentUser?.uid)!)
                .child("Ratings")
                .child("Venues")
                .observe(.childAdded, with: { snapshot in

                    if(snapshot.exists()){
                        let value = snapshot.value as? NSDictionary


                        let ratingType : Double = (value?["ratingType"] as? Double)!
                        print("Rating Type: \(ratingType)")
                        let overallRating : Double = (value?["overall_rating"] as? Double)!
                        let username : String = (value?["username"] as? String)!
                        let body : String = (value?["rateBody"] as? String)!
                        let artistName : String = (value?["artistName"] as? String)!
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

                        newRating.artistName = artistName

                        print("Adding Rating: " + newRating.toString())
                        self.ratings.append(newRating)
                        self.tableView.reloadData()
                    }
                }) { (error) in
                    print(error.localizedDescription)
            }
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ratings.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRating = ratings[indexPath.row]

        performSegue(withIdentifier: "myRating", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : Ratingcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Ratingcell

        print(ratings[indexPath.row].artistName)
        cell.titleLabel.text = ratings[indexPath.row].artistName
        cell.descriptionLabel.text = ratings[indexPath.row].body
        cell.ratingImage.image = UIImage(named: "r_" + (Int(ratings[indexPath.row].overall_rating)).description)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myRating") {
            let vc : SpecificRatingViewController = segue.destination as! SpecificRatingViewController

            vc.curRating = selectedRating
        }
    }
}
