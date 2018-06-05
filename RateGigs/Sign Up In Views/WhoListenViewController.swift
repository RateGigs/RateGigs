//
//  CriticalViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/10/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit

class WhoListenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
    var user = User()
    var selectedItems = [String]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    var titles = ["THE WEEKND", "LUKE BRYAN", "COLDPLAY", "THE WHO", "AVICII", "BILLY JOEL", "BON JOVI", "BRETT ELDREDGE", "CHASE RICE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        width = width - 10
        layout.itemSize = CGSize(width: 178, height: 120)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionView!.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfileCell
        
        cell.label.text = titles[indexPath.row]
         cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItems.append(titles[indexPath.row])
        if(selectedItems.count == 3){
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : DistanceViewController = segue.destination as! DistanceViewController
        
        user.artists = selectedItems
        vc.user = user
    }
}

