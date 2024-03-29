//
//  HypeTableViewController.swift
//  HYPE
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HypeTableViewController: UITableViewController, UITextFieldDelegate {

    //creating our refresh UI instance of type UIRefreshControl
    var refresh: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //accessing our refresh variable created above and giving it a title
        refresh.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        //calling a method called add target that is tied to loadData when the value is changed
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        //adds the subview to the tableView
        self.tableView.addSubview(refresh)
        //calling our loadData function
        loadData()
        
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAddAlert()
    }
    
    //our alert function that allows us to input a Hype
    func presentAddAlert() {
        let alertController = UIAlertController(title: "Get Hype", message: "What is hype may never die", preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Hype has a limit of 45 characters."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            textField.delegate = self
        }
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let hypeText = alertController.textFields?.first?.text else {return}
            if hypeText != "" {
                HypeController.shared.saveHype(text: hypeText, completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive)
        
        alertController.addAction(addHypeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    
    
    //Helper function - allows us to seperate logic - everytime the fetch function is called, it will reload the tableView
    @objc func loadData() {
        //accessing the fetchHype function
        HypeController.shared.fetchHype { (success) in
            //if successful...
            if success {
                DispatchQueue.main.async {
                    //reload the tableView whenever we fetch a hype; on the main thread
                    self.tableView.reloadData()
                    //end the refresh animation
                    self.refresh.endRefreshing()
                }
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HypeController.shared.hypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)

        // Configure the cell...
        let hype = HypeController.shared.hypes[indexPath.row]
        cell.textLabel?.text = hype.hypeText
        cell.detailTextLabel?.text = hype.timestamp.formatDate()

        return cell
    }
    

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
