//
//  SearchController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 12/10/17.
//  Copyright © 2017 Scrappy Technologies. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Cider
import NVActivityIndicatorView

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var ref = DatabaseReference()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var loaderView: NVActivityIndicatorView!
    var selectedArtist = ""
    var artistID = ""
    var selectedImage = UIImage()
    var searching = false


    let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkpQN0tYN0w1ODgifQ.eyJpc3MiOiI3QVdYNTJTS0g2IiwiaWF0IjoxNTIwOTUwMjQ2LCJleHAiOjE1MzY3MTgyNDZ9.k31wi4pfS4MAoUaXF1WCkMVRFaksLw2IF1waQP5N1EOIcM9I8cHDhTyIZQgMY6uPyXBREIEJhA0pHbYMG2eePA"
    var cider : CiderClient!
    
    var dict = [String:String]()
    
    var artists : [String] = ["Luke Bryan", "Coldplay", "Jeremy Zucker", "AJR", "All Time Low", "Ariana Grande", "Avicii", "Billy Joel", "Bon Jovi", "Ed Sheeran"]

    var filteredSearch = [Artist]()
    
    override func viewWillAppear(_ animated: Bool) {
        artists = []
        
        loaderView.type = .audioEqualizer
        loaderView.center = self.view.center
        self.view.addSubview(loaderView)
        loaderView.isHidden = true
        
        
        tableView.reloadData()
        searchBar.returnKeyType = .search
    }
    
    func showLoader(){
        loaderView.isHidden = false
        loaderView.startAnimating()
    }
    
    func hideLoader(){
        loaderView.isHidden = true
        loaderView.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cider = CiderClient(storefront: .unitedStates, developerToken: developerToken)
        searchBar.delegate = self
        searchBar.returnKeyType = .default
        ref = Database.database().reference()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SearchCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchCell
        
        if(searching){
            cell.mainText.text = filteredSearch[indexPath.row].name
        }else{
            cell.mainText.text = artists[indexPath.row]
        }
        
        cell.artistImage.image = filteredSearch[indexPath.row].image
        
        cell.subText.text = "Artist"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching){
            return filteredSearch.count
        }else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(searching){
            selectedArtist = filteredSearch[indexPath.row].name
            artistID = filteredSearch[indexPath.row].id
            selectedImage = filteredSearch[indexPath.row].image
        }else{
            selectedArtist = filteredSearch[indexPath.row].name
            selectedImage = filteredSearch[indexPath.row].image
        }
        
        self.performSegue(withIdentifier: "profile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profile"){
            let vc = segue.destination as! ArtistViewController
            vc.artistName = selectedArtist
            vc.artistID = self.artistID
            vc.headerImage = self.selectedImage
            vc.artist = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        showLoader()
        if(searching){
            searchString(string: searchBar.text!)
        }
        searchBar.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(searching){
            searchString(string: searchBar.text!)
        }
        self.view.endEditing(true)
        return true;
    }
    
    func searchString(string: String){
        //Used to search the string in the bar.
        filteredSearch = []
        
        cider.search(term: string, types: [.artists, .albums]){ result, error in
            let artists = result?.artists?.data
            
        
            if(artists != nil){
                DispatchQueue.global(qos: .userInteractive).async(execute: {
                    for i in 0...artists!.count - 1{
                        let artist = Artist()
                        
                        let id = artists![i].id
                        
                        let name = artists![i].attributes?.name
                        
                        self.cider.artist(id: id) { result, error in
                            let albumID = result?.relationships?.albums.data?.first?.id
                            if(albumID != nil){
                                self.cider.album(id: albumID!) { result, error in
                                    let album = result
                                    
                                    print("FOUND: " + (album?.attributes?.name)!)
                                    if(album != nil){
                                        let url = album?.attributes?.artwork.url(forWidth: 200)
                                        
                                        let data = try? Data(contentsOf: url!)
                                        let image = UIImage(data: data!)
                                        
                                        artist.setImage(image: image!)
                                        
                                        self.ref.child("images").child(id).setValue(url?.absoluteString)

                                        DispatchQueue.main.async {
                                            if(i == (artists?.count)! - 1){
                                                self.hideLoader()
                                            }
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                                
                                artist.setName(name: name!)
                                artist.setID(id: id)
                                self.filteredSearch.append(artist)
                                print("adding " + artist.name)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                })
            }
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        if(searching){
            searchString(string: searchBar.text!)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == "" || searchBar.text == nil){
            searching = false
            tableView.reloadData()

        }else{
            searching = true
//            let stringToSearch = searchBar.text?.lowercased()
            
            //filteredData = artists.filter({$0.lowercased().range(of: stringToSearch!) != nil})
            //tableView.reloadData()
        }
    }
}

