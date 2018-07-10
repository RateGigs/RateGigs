//
//  PageInfoViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/21/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import Firebase

class PageInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ratingType = "simple"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    var artistKey = ""
    var artistName = ""
    var ref = DatabaseReference()
    var ratings = [Rating]()
    var isArtist = false
    var selectedRating : Rating!
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = artistName
        self.ratings = []
        self.tableView.reloadData()
        
        ref = Database.database().reference()
        
        var path = ""
        if(isArtist){
            path = "Artists"
        }else{
            path = "Venues"
        }
        
        ref.child(path).child(artistKey).child("Ratings").observe(.childAdded, with: { snapshot in
                
                if(snapshot.exists()){
                    let value = snapshot.value as? NSDictionary
                    

                    let ratingType : Double = (value?["ratingType"] as? Double)!
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
                        production = (value?["production"] as? Double)!
                        crowdEngagement = (value?["crowd_engagement"] as? Double)!
                        
                        rawTalent = (value?["raw_talent"] as? Double)!
                        setList = (value?["set_list"] as? Double)!
                    }
                    
                    let newRating = Rating(ratingType: Int(ratingType), setList: setList, rawTalent: rawTalent, production: production, crowdEngagement: crowdEngagement, overallRating: overallRating, username: username, body: body, location: location, date: date)
                    
                    print("Adding Rating: " + newRating.toString())
                    self.ratings.append(newRating)
                    
                    self.tableView.reloadData()
                }
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(ratings.count <= 0){
            self.tableView.separatorColor = #colorLiteral(red: 0.1674376428, green: 0.1674425602, blue: 0.167439878, alpha: 1)
        }else{
            self.tableView.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    @IBAction func rateClicked(_ sender: Any) {
        
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
    @IBAction func showRatings(_ sender: Any) {
        performSegue(withIdentifier: "showRatings", sender: nil)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(ratings.count > 0){
            let cell : ViewRatingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewRatingTableViewCell
            cell.nameLabel.text = ratings[indexPath.row].username
            cell.ratingTextLabel.text = ratings[indexPath.row].body
            cell.ratingImage.image = UIImage(named: "r_" + (Int(ratings[indexPath.row].overall_rating)).description)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "none", for: indexPath)
        
        return cell
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(ratings.count > 0){
            return ratings.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(ratings.count > 0){
            return 84
        }
        return 143
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedRating = ratings[indexPath.row]
        print(selectedRating.toString())
        performSegue(withIdentifier: "viewRating", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "rate"){
            let vc : RateViewController = segue.destination as! RateViewController
            vc.rateType = ratingType
            vc.artistName = artistName
        }else{
            let vc : SpecificRatingViewController = segue.destination as! SpecificRatingViewController
            vc.artistName = self.artistName
            vc.curRating = self.selectedRating
        }
    }
}
