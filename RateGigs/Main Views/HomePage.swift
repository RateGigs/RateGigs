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

class HomePage: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var loaderView: NVActivityIndicatorView!
    
    @IBOutlet var upAndComing: UICollectionView!
    @IBOutlet var topRatedArtists: UICollectionView!
    @IBOutlet var topRatedVenues: UICollectionView!
    let dt = ""
    var cider : CiderClient!
    
    var ref = DatabaseReference()
    var loaded = false
    var artist = false
    var selectedArtist = ""
    var selectedArtistID = ""
    var artists = [String]()
    var upAndComingTitles = [String]()
    var upAndComingKeys = [String]()

    var festivals = [String]()
    var keys = [String]()
    var Vkeys = [String]()
    var artistImages = [String : UIImage]()
    var artistImageHeaders = [String : UIImage]()

    var collectionViews = [UICollectionView]()
    var selectedImage: UIImage!

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
            loadArtistData()
        }
        
        self.tabBarController?
            .navigationController?
            .navigationItem.setHidesBackButton(true, animated: false)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 35))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "Rate_Gigs_White_Small")
        imageView.image = image
        navigationItem.titleView = imageView
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
        cider = CiderClient(storefront: .unitedStates, developerToken: dt)
    }
    
    func loadImage(id: String){
        ref.child("images").child(id)
            .queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    let url = URL(string: snapshot.value as! String)

                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)

                    //Add the loaded image to the array
                    self.artistImages[snapshot.key] = image

                    if(self.artistImages.count == 5){
                        self.showCollectionView()
                    }

                    DispatchQueue.main.async {
                        self.upAndComing.reloadData()
                        self.topRatedArtists.reloadData()
                    }
            }) { (error) in
                print(error.localizedDescription)
        }

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
                self.upAndComingKeys.append(snapshot.key)
                self.upAndComingTitles.reverse()

                DispatchQueue.main.async { // 2
                    self.loadImage(id: snapshot.key)
                }
            
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
                
            DispatchQueue.main.async { // 2
                self.loadImage(id: artistID)
            }

            self.keys.reverse()
            self.keys.append(artistID)
            self.keys.reverse()
                
            self.artists.reverse()
            self.artists.append(artistName)
            self.artists.reverse()
            
            self.topRatedArtists.reloadData()
        })
        
        ref.child("Venues")
            .queryOrdered(byChild: "adjusted_rating").queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) -> Void in
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
            selectedArtistID = upAndComingKeys[indexPath.row]
            selectedImage = artistImages[selectedArtistID]

            print("Selected \(selectedArtistID)")
            artist = true
        case 1:
            selectedArtist = artists[indexPath.row]
            selectedArtistID = keys[indexPath.row]
            selectedImage = artistImages[selectedArtistID]

            artist = true
        case 2:
            selectedArtist = festivals[indexPath.row]
            selectedArtistID = Vkeys[indexPath.row]
            switch(selectedArtist.lowercased()){
            case "mo pop":
               selectedImage = UIImage(named: "mopop")
                break
            case "prime":
                selectedImage = UIImage(named: "prime")
                break
            case "common ground":
                selectedImage = UIImage(named: "commonground")
                break
            case "breakaway":
                selectedImage = UIImage(named: "breakaway")
                break
            case "wayside central":
                selectedImage = UIImage(named: "wayside")
                break
            case "20 monroe live":
                selectedImage = UIImage(named: "20monroe")
                break
            case "masonic temple":
                selectedImage = UIImage(named: "masonictemple")
                break
            case "lollapalooza":
               selectedImage = UIImage(named: "lollapalooza")
                break

            default:
                break
            }

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
            vc.headerImage = self.selectedImage
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

            if(artistImages.count > indexPath.row){
                cell.image.image = artistImages[upAndComingKeys[indexPath.row]]
            }
            
            return cell
        case 1:
            let cell : HomeCollectionViewCell = topRatedArtists.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            
            if(artistImages.count > indexPath.row){
                cell.image.image = artistImages[keys[indexPath.row]]
            }
            
            cell.textLabel.text = artists[indexPath.row]
            return cell
        case 2:
            let cell : HomeCollectionViewCell = topRatedVenues.dequeueReusableCell(withReuseIdentifier: "festivalCell", for: indexPath) as! HomeCollectionViewCell
            
            cell.textLabel.adjustsFontSizeToFitWidth = true
            cell.textLabel.minimumScaleFactor = 0.1
            cell.textLabel.text = festivals[indexPath.row]

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
            case "masonic temple":
                cell.image.image = UIImage(named: "masonictemple")
                break
            case "lollapalooza":
                cell.image.image = UIImage(named: "lollapalooza")
                break

            default:
                break
            }
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

