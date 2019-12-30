//
//  AccountSettingsTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountSettingsTableViewController: UITableViewController {

    @IBOutlet var accountTable: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTable.delegate = self
        profileImage.makeRounded()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nickname = UserDefaults.standard.string(forKey: ConstantUser.nickName)
        let firstName = UserDefaults.standard.string(forKey: ConstantUser.firstName)
        let lastName = UserDefaults.standard.string(forKey: ConstantUser.lastName)
        self.navigationItem.title = "Account Settings"
        nickNameLabel.text = nickname
        fullNameLabel.text = firstName! + " " + lastName!
        accountTable.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 1:
            return 3
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 1{
            let logoutMenu = UIAlertController(title: "Signout",
                                               message: "Do you want to logout?",
                                               preferredStyle: .actionSheet)
            logoutMenu.addAction(UIAlertAction(title: "Signout", style: .destructive, handler: { (UIAlertAction) in
                self.logout()
            }))
            logoutMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
            self.present(logoutMenu, animated: true, completion: nil)
        }
    }
    
    private func logout(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            print("LOGGEDOUT!")
            UserDefaults.standard.removeObject(forKey: ConstantUser.firstName)
            UserDefaults.standard.removeObject(forKey: ConstantUser.lastName)
            UserDefaults.standard.removeObject(forKey: ConstantUser.nickName)
            UserDefaults.standard.removeObject(forKey: ConstantUser.email)
            UserDefaults.standard.removeObject(forKey: ConstantUser.gender)
            UserDefaults.standard.removeObject(forKey: ConstantUser.birthday)
            self.navigationController?.popViewController(animated: true)
            
        }catch let signoutError as NSError{
            print("Error Signout : \(signoutError)")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(accountTable, cellForRowAt: indexPath)
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.selectionStyle = .none
        default:
            break
        }

        // Configure the cell...

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
