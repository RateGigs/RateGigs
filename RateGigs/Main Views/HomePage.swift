//
//  FirstViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/10/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Cider
import NVActivityIndicatorView
//
//class loaderView: NVActivityIndicatorView{
//
//}
class HomePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var loaderView: NVActivityIndicatorView!
    
    @IBOutlet var upAndComing: UICollectionView!
    @IBOutlet var topRatedArtists: UICollectionView!
    @IBOutlet var topRatedVenues: UICollectionView!
    let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkpQN0tYN0w1ODgifQ.eyJpc3MiOiI3QVdYNTJTS0g2IiwiaWF0IjoxNTIwOTUwMjQ2LCJleHAiOjE1MzY3MTgyNDZ9.k31wi4pfS4MAoUaXF1WCkMVRFaksLw2IF1waQP5N1EOIcM9I8cHDhTyIZQgMY6uPyXBREIEJhA0pHbYMG2eePA"
    var cider : CiderClient!
    
    var ref = DatabaseReference()
    var loaded = false
    var artist = false
    var selectedArtist = ""
    var selectedArtistID = ""
    var artists = [String]()
    var upAndComingTitles = [String]()
    var festivals = [String]()
    var keys = [String]()
    var Vkeys = [String]()
    var artistImages = [UIImage]()
    
    var collectionViews = [UICollectionView]()
    
    override func viewWillAppear(_ animated: Bool) {
        collectionViews.append(upAndComing)
        collectionViews.append(topRatedVenues)
        collectionViews.append(topRatedArtists)
                
        ref = Database.database().reference()
        
        self.view.addSubview(loaderView)
        loaderView.center = self.view.center
        
        loaderView.type = .audioEqualizer
        
        if(!loaded){
            loadUpAndComingData()
        }
        
        self.tabBarController?
            .navigationController?
            .navigationItem.setHidesBackButton(true, animated: false)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "Rate_Gigs_White_Small")
        imageView.image = image
        navigationItem.titleView = imageView
        
        if(!loaded){
            
            loadArtistData()
        }
    }
    
    func hideCollectionViews(){
        for i in 0...collectionViews.count - 1{
            collectionViews[i].isHidden = true
        }
    }
    
    func showCollectionView(){
        self.loaderView.stopAnimating()
        
        for i in 0...collectionViews.count - 1{
            collectionViews[i].isHidden = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cider = CiderClient(storefront: .unitedStates, developerToken: developerToken)
    }
    
    func loadImage(id: String){
        DispatchQueue.global(qos: .default).async(execute: {
            self.cider.artist(id: id) { result, error in
                let albumID = result?.relationships?.albums.data?.first?.id
                if(albumID != nil){
                    self.cider.album(id: albumID!) { result, error in
                        let album = result
                        
                        if(album != nil){
                            let url = album?.attributes?.artwork.url(forWidth: 130)
                            
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)
                            
                            //Add the loaded image to the array
                            self.artistImages.append(image!)
                            if(self.artistImages.count == 5){
                                self.showCollectionView()
                            }
                            DispatchQueue.main.async {
                                self.topRatedArtists.reloadData()
                            }
                        }
                    }
                }
            }
        })
            
        DispatchQueue.main.async(execute: {
            self.showCollectionView()
        })
    }
    
    func loadUpAndComingData(){
        ref.child("UpAndComing").queryLimited(toLast: 5).observe(.childAdded, with: { (snapshot) -> Void in
            let artistName : String = snapshot.value as! String
                print(artistName)
                self.upAndComingTitles.reverse()
                self.upAndComingTitles.append(artistName)
                self.upAndComingTitles.reverse()
            
                self.upAndComing.reloadData()
            })
    }
    
    func loadArtistData(){
        loaded = true
        ref.child("Artists")
            .queryOrdered(byChild: "adjusted_rating").queryLimited(toLast: 5).observe(.childAdded, with: { (snapshot) -> Void in
            let postDict = snapshot.value as? [String : Any] ?? [:]
            
            let artistID : String = snapshot.key
            let artistName : String = postDict["name"] as! String
                
            self.loadImage(id: artistID)
            self.keys.reverse()
            self.keys.append(artistID)
            self.keys.reverse()
                
            self.artists.reverse()
            self.artists.append(artistName)
            self.artists.reverse()
            
            self.topRatedArtists.reloadData()
        })
        
        ref.child("Venues")
            .queryOrdered(byChild: "adjusted_rating").queryLimited(toLast: 5).observe(.childAdded, with: { (snapshot) -> Void in
                let postDict = snapshot.value as? [String : Any] ?? [:]
                
                let venueID : String = snapshot.key
                let artistName : String = postDict["name"] as! String
                
                self.Vkeys.reverse()
                self.Vkeys.append(venueID)
                self.Vkeys.reverse()
                
                self.festivals.reverse()
                self.festivals.append(artistName)
                self.festivals.reverse()
                
                self.topRatedVenues.reloadData()
            })
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return upAndComingTitles.count
        case 1:
            return artists.count
        case 2:
            return festivals.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch collectionView.tag {
        case 0:
            selectedArtist = upAndComingTitles[indexPath.row]
            selectedArtistID = keys[indexPath.row]
            artist = true
        case 1:
            selectedArtist = artists[indexPath.row]
            selectedArtistID = keys[indexPath.row]
            artist = true
        case 2:
            selectedArtist = festivals[indexPath.row]
            selectedArtistID = Vkeys[indexPath.row]
            artist = false
        default:
            selectedArtist = artists[indexPath.row]
            artist = true
        }
        
        self.performSegue(withIdentifier: "profile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profile"){
            let vc : ArtistViewController = segue.destination as! ArtistViewController
            vc.artistName = selectedArtist
            vc.artist = self.artist
            vc.artistID = self.selectedArtistID
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.tag)
    
        
        switch collectionView.tag {
        case 0:
            let cell : HomeCollectionViewCell = upAndComing.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            cell.textLabel.text = upAndComingTitles[indexPath.row]
            return cell
        case 1:
            let cell : HomeCollectionViewCell = topRatedArtists.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            
            if(artistImages.count > indexPath.row){
             //   cell.image.image = artistImages[indexPath.row]
            }
            
            cell.textLabel.text = artists[indexPath.row]
            return cell
        case 2:
            let cell : HomeCollectionViewCell = topRatedVenues.dequeueReusableCell(withReuseIdentifier: "festivalCell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            cell.textLabel.text = festivals[indexPath.row]
            return cell
        default:
            let cell : HomeCollectionViewCell = upAndComing.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            cell.textLabel.text = artists[indexPath.row]
            return cell
        }
    }
}

