//
//  OtherSignInTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class OtherSignInTableViewController: UITableViewController, DownloadUserProtocol {
    
    func itemDownloadUser(item: UserModel) {
        if item.firstName != nil{
            UserDefaults.standard.set(item.userId ?? nil, forKey: ConstantUser.userId)
            UserDefaults.standard.set(item.firstName ?? nil, forKey: ConstantUser.firstName)
            UserDefaults.standard.set(item.lastName ?? nil, forKey: ConstantUser.lastName)
            UserDefaults.standard.set(item.nickname ?? nil, forKey: ConstantUser.nickName)
            UserDefaults.standard.set(item.email ?? nil, forKey: ConstantUser.email)
            UserDefaults.standard.set(item.gender ?? nil, forKey: ConstantUser.gender)
            UserDefaults.standard.set(item.birthday ?? nil, forKey: ConstantUser.birthday)
            UserDefaults.standard.set(item.profilepic ?? nil, forKey: ConstantUser.profilepic)
            self.navigationController!.popToRootViewController(animated: true)
        }else{
            let vc = storyboard!.instantiateViewController(withIdentifier: "profile")
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    func itemUserError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.navigationController!.popToRootViewController(animated: true)
        }))
        self.navigationController!.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance()?.signIn()
        }else if indexPath.row == 1{
            let loginManager = LoginManager()
            if let _ = AccessToken.current{
                loginManager.logOut()
            }else{
                loginManager.logIn(permissions: ["email"], from: self){
                    [weak self] (result, error) in
                    guard error == nil else{
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    guard let result = result, !result.isCancelled else{ return }
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: result.token!.tokenString)
                    
                    Auth.auth().signIn(with: credential){
                        (authResult, error) in
                        if let error = error{
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                                self?.navigationController!.popToRootViewController(animated: true)
                            }))
                            self?.navigationController!.present(alert, animated: true, completion: nil)
                            loginManager.logOut()
                            return
                        }
                        
                        let downloadUser = DownloadUser()
                        downloadUser.delegate = self
                        downloadUser.getCurrentUserprofile(uid: (authResult?.user.uid)!)
                    }
                }
            }
            
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
