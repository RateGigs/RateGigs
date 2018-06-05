//
//  CreateArtistTableViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 2/12/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Cider

class CreateArtistTableViewController: UITableViewController {

    var ref = DatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       ref = Database.database().reference()
    }
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var artistGenreField: UITextField!
    @IBOutlet var artistNameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @IBAction func done(_ sender: Any) {
        let name = artistNameField.text
        let id = artistGenreField.text
       
        let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkpQN0tYN0w1ODgifQ.eyJpc3MiOiI3QVdYNTJTS0g2IiwiaWF0IjoxNTIwOTUwMjQ2LCJleHAiOjE1MzY3MTgyNDZ9.k31wi4pfS4MAoUaXF1WCkMVRFaksLw2IF1waQP5N1EOIcM9I8cHDhTyIZQgMY6uPyXBREIEJhA0pHbYMG2eePA"
        let cider = CiderClient(storefront: .unitedStates, developerToken: developerToken)
        
        cider.artist(id: "337290194"){ result, error in
           // print(result?.attributes.)

        }
        
        
        cider.search(term: name!, types: [.artists, .albums, .curators]){ result, error in
            let artists = result?.artists?.data
            let albums = result?.albums?.data?.first

            DispatchQueue.global(qos: .default).async(execute: {
                
                DispatchQueue.main.async(execute: {
                    
                    self.genreLabel.text = artists?.first?.attributes?.genreNames.first
                    
                    self.nameLabel.text = artists?.first?.attributes?.name
                    
                    self.idLabel.text = artists?.first?.id
                    
                    let url = result?.albums?.data?.first?.attributes?.artwork.url(forWidth: 80)
                    
                    let data = try? Data(contentsOf: url!)
                    self.imageView.image = UIImage(data: data!)
                    
                })
            })
            
            
        }
        
        cider.artist(id: "337290194") { result, error in
            print(result?.attributes?.editorialNotes?.standard)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 2
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
