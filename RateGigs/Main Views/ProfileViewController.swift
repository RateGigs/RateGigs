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
    
    @IBOutlet var venueCountLabel: UILabel!
    @IBOutlet var artistCountLabel: UILabel!
    
    var artistRatingNames = [String]()
    var artistRatingIDs = [String]()
    var artistRatingKeys = [String]()
    
    var venueRatingKeys = [String]()
    var venueRatingNames = [String]()
    var venuetRatingIDs = [String]()
    
    var selectedArtistID = ""
    var selectedArtistKey = ""
    var selectedArtistName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadUserInfo()
        loadVenueReviews()
        loadArtistReviews()
    }
    
    func loadUserInfo(){
        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                print(postDict)
                let artistID : String = snapshot.key
                let username = postDict["username"]
                self.usernameLabel.text = username as! String
            
            }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    func loadArtistReviews(){
        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .child("Ratings")
            .child("Artists")
            .observe(.childAdded, with: { snapshot in

                self.artistRatingKeys.append(snapshot.key)
                
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let artistName = rest.key
                    let artistID = rest.value
                    
                    self.artistRatingIDs.append(artistID as! String)
                    self.artistRatingNames.append(artistName)
                }
                
                self.artistCountLabel.text = "ARTISTS (" + self.artistRatingNames.count.description + ")"
                self.artistsCollectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func loadVenueReviews(){
        ref.child("users")
            .child((Auth.auth().currentUser?.uid)!)
            .child("Ratings")
            .child("Venues")
            .observe(.childAdded, with: { snapshot in
                
                self.venueRatingKeys.append(snapshot.key)
                
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let venueName = rest.key
                    let venueID = rest.value
                    
                    self.venuetRatingIDs.append(venueID as! String)
                    self.venueRatingNames.append(venueName)
                }
                
                self.venueCountLabel.text = "VENUES (" + self.venueRatingNames.count.description + ")"
                self.venueCollectionView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            return artistRatingNames.count
        }else{
            return venueRatingNames.count
        }
//        switch section {
//        case 0:
//            return artistRatingNames.count
//        case 1:
//            return venueRatingNames.count
//        default:
//            break
//        }
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if(collectionView.tag == 0){
            if(indexPath.row == 9){
                performSegue(withIdentifier: "more", sender: nil)
            }else{
                
                if(indexPath.section == 0){
                    print(artistRatingKeys[indexPath.row])
                    selectedArtistID = artistRatingIDs[indexPath.row]
                    selectedArtistKey = artistRatingKeys[indexPath.row]
                    selectedArtistName = artistRatingNames[indexPath.row]
                    performSegue(withIdentifier: "showRating", sender: nil)
                }else{
                    
                }
            }
        }else{
            if(indexPath.row == 9){
                performSegue(withIdentifier: "more", sender: nil)
            }else{
                
                if(indexPath.section == 0){
                    print(artistRatingKeys[indexPath.row])
                    selectedArtistID = venuetRatingIDs[indexPath.row]
                    selectedArtistKey = venueRatingKeys[indexPath.row]
                    selectedArtistName = venueRatingNames[indexPath.row]
                    performSegue(withIdentifier: "showRating", sender: nil)
                }else{
                    
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row < 9){
            if(collectionView.tag == 0){
                let cell : HomeCollectionViewCell = artistsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
                cell.textLabel.text = artistRatingNames[indexPath.row]
                return cell
            }else{
                let cell : HomeCollectionViewCell = venueCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
                cell.textLabel.text = venueRatingNames[indexPath.row]
                return cell
            }
        
            
        }else{
            let cell = artistsCollectionView.dequeueReusableCell(withReuseIdentifier: "more", for: indexPath) as UICollectionViewCell
            
            cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showRating"){
            let vc : SpecificRatingViewController = segue.destination as! SpecificRatingViewController
            
            vc.artistID = selectedArtistID
            vc.ratingID = selectedArtistKey
            vc.artistName = self.selectedArtistName
            
        }
    }
}
