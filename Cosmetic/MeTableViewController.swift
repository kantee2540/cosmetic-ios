//
//  MeTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 25/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class MeTableViewController: UITableViewController {

    @IBOutlet var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "MyAccount"
        mainTable.delegate = self
        mainTable.dataSource = self
        setAccountUser()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            return 1
        }
        else if section == 1{
            return 3
        }
        else if section == 2{
            return 3
        }
        else if section == 3{
            return 2
        }
        else{
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && indexPath.row == 0{
            if Auth.auth().currentUser != nil{
                let signinVc = storyboard?.instantiateViewController(withIdentifier: "accountsetting")
                self.navigationController?.pushViewController(signinVc!, animated: true)
            }
            else{
                let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
                self.navigationController?.pushViewController(accountVc!, animated: true)
            }
        }
        
    }
    
    func setAccountUser(){
        let accountCell = self.mainTable.cellForRow(at: IndexPath(row: 0, section: 0))
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user{
                accountCell?.textLabel?.text = user.email
                accountCell?.detailTextLabel?.text = user.uid
            }
        }
        else{
            accountCell?.textLabel?.text = "Sign in"
            accountCell?.detailTextLabel?.text = "Save your cosmetics list"
        }
        mainTable.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(mainTable, cellForRowAt: indexPath)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if Auth.auth().currentUser != nil{
                let user = Auth.auth().currentUser
                if let user = user{
                    cell.textLabel?.text = user.email
                    cell.detailTextLabel?.text = user.uid
                }
            }else{
                cell.textLabel?.text = "Sign in"
                cell.detailTextLabel?.text = "Save your cosmetics list"
            }

        default: break
        }
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
