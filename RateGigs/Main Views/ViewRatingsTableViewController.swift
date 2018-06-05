//
//  ViewRatingsTableViewController.swift
//  RateGigs
//
//  Created by Bryan Caragay on 1/9/18.
//  Copyright © 2018 Scrappy Technologies. All rights reserved.
//

import UIKit

class ViewRatingsTableViewController: UITableViewController {

    var artistName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ViewRatingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewRatingTableViewCell

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "viewRating", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : SpecificRatingViewController = segue.destination as! SpecificRatingViewController
        vc.artistName = artistName
        
    }
}
