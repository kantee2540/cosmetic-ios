//
//  MeTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 25/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class MeTableViewController: UITableViewController, DownloadUserProtocol {
    func itemDownloadUser(item: UserModel) {
        if item.userId != nil{
            Library.setUserDefault(user: item)
            removeSpinner()
            self.tableView.reloadData()
        }else{
            removeSpinner()
        }
    }
    
    func itemUserError(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "MyAccount"
        self.tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seemytopic"{
            let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
            let destination = segue.destination as? MyTopicTableViewController
            destination?.userId = userId
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            return 1
        }
        else if section == 1{
            if Auth.auth().currentUser != nil{
                return 2
            }else{
                return 0
            }
        }
        else{
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0{
            if Auth.auth().currentUser != nil && UserDefaults.standard.string(forKey: ConstantUser.firstName) != nil{
                let signinVc = storyboard?.instantiateViewController(withIdentifier: "accountsetting")
                self.navigationController?.pushViewController(signinVc!, animated: true)
                
            }else if Auth.auth().currentUser != nil && UserDefaults.standard.string(forKey: ConstantUser.firstName) == nil{
                let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileTableViewController
                self.navigationController?.pushViewController(profileVc, animated: true)
                
            }
            else{
                let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
                self.navigationController?.pushViewController(accountVc!, animated: true)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(self.tableView, cellForRowAt: indexPath)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if Auth.auth().currentUser != nil{
                let user = Auth.auth().currentUser
                if user != nil{
                    let firstName = UserDefaults.standard.string(forKey: ConstantUser.firstName)
                    let lastName = UserDefaults.standard.string(forKey: ConstantUser.lastName)
                    if firstName != nil{
                        cell.textLabel?.text = UserDefaults.standard.string(forKey: ConstantUser.nickName)
                        cell.detailTextLabel?.text = (firstName ?? "Not set") + " " + (lastName ?? "???")
                    }else{
                        //Check user again
                        showSpinner(onView: self.view)
                        let downloadUser = DownloadUser()
                        downloadUser.delegate = self
                        downloadUser.getCurrentUserprofile(uid: user!.uid)
                        ///
                        cell.textLabel?.text = user?.email
                        cell.detailTextLabel?.text = "Please complete your information"
                    }
                }
            }else{
                cell.textLabel?.text = "Sign in"
                cell.detailTextLabel?.text = "Save your cosmetics list"
                
            }

        default: break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if Auth.auth().currentUser == nil{
                return "Join today to save your cosmetics to your desk and share the cosmetics to your friends!"
            }else{
                return nil
            }
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 70
        }
        if indexPath.section == 1 && Auth.auth().currentUser == nil{
            return 0.01
        }else if indexPath.section == 2 && Auth.auth().currentUser == nil{
            return 0.01
        }else{
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && Auth.auth().currentUser == nil{
            return 0.01
        }else if section == 2 && Auth.auth().currentUser == nil{
            return 0.01
        }else{
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 && Auth.auth().currentUser == nil{
            return 0.0
        }else if section == 2 && Auth.auth().currentUser == nil{
            return 0.0
        }else{
            return UITableView.automaticDimension
        }
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
