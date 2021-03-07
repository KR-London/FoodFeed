//
//  commentTableViewController.swift
//  FoodFeed
//
//  Created by Kate Roberts on 07/03/2021.
//  Copyright © 2021 Daniel Haight. All rights reserved.
//

import UIKit

class commentTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "commentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
       // self.tableView.estimatedRowHeight = 480
       // self.tableView.rowHeight = UITableView.automaticDimension
       // self.tableView.setNeedsLayout()
      //  self.tableView.layoutIfNeeded()
      //  self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.tableView.rowHeight = 200
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setUpCommentsView(margins: UILayoutGuide){
        // backgroundColor = UIColor(white: 0.1, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.3),
            // bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            // leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -10),
            view.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.7)
        ])
        
        view.layer.cornerRadius = 20.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! commentTableViewCell
        
        //cell.middleLabel.text = items[indexPath.row]
        // cell.leftLabel.text = items[indexPath.row]
        // cell.rightLabel.text = items[indexPath.row]
        
        return cell
    }
    
    
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(indexPath.row * 1000)
//    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
