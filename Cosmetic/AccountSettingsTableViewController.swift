//
//  AccountSettingsTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class AccountSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CollectUserdataDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var selectprofileImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        profileImage.makeRounded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nickname = UserDefaults.standard.string(forKey: ConstantUser.nickName)
        let firstName = UserDefaults.standard.string(forKey: ConstantUser.firstName)
        let lastName = UserDefaults.standard.string(forKey: ConstantUser.lastName)
        let profileURL = UserDefaults.standard.string(forKey: ConstantUser.profilepic)
        
        self.navigationItem.title = "Account Settings"
        nickNameLabel.text = nickname
        fullNameLabel.text = firstName! + " " + lastName!
        
        if profileURL != ""{
            profileImage.downloadImage(from: (URL(string: profileURL!) ?? URL(string: ConstantDefaultURL.defaultImageURL))!)
        }
        self.tableView.reloadData()
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
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.section == 2 && indexPath.row == 0{
            let logoutMenu = UIAlertController(title: "Signout",
                                               message: "Do you want to logout?",
                                               preferredStyle: .actionSheet)
            logoutMenu.addAction(UIAlertAction(title: "Signout", style: .destructive, handler: { (UIAlertAction) in
                self.logout()
            }))
            logoutMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
            
            if let popoverController = logoutMenu.popoverPresentationController{
                popoverController.sourceView = cell
            }
            
            self.present(logoutMenu, animated: true, completion: nil)
        }
    }
    @IBAction func selectImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        let alert = UIAlertController(title: "Change profile picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) -> Void in
            imagePicker.sourceType = .camera
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: {(action) -> Void in
            imagePicker.sourceType = .photoLibrary
            self.navigationController?.present(imagePicker, animated: true, completion: nil)
        }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
            
        }))
        
        if let popoverController = alert.popoverPresentationController{
            popoverController.sourceView = selectprofileImage
            popoverController.sourceRect = selectprofileImage.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)!
        
        let collectionUser = CollectUserdata()
        collectionUser.delegate = self
        collectionUser.updateProfilePicture(userId: userId, image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    func insertDataSuccess() {
        
    }
    
    func insertDataFailed() {
        
    }
    
    func updateProfileSuccess(imageURL: String) {
        
        if imageURL != ""{
            UserDefaults.standard.set(imageURL, forKey: ConstantUser.profilepic)
            profileImage.downloadImage(from: URL(string: imageURL)!)
        }else{
            Library.displayAlert(targetVC: self, title: "Error", message: "Please try another image")
        }
        self.tableView.reloadData()
    }
    
    private func logout(){
        let loginManager = LoginManager()
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            loginManager.logOut()
            GIDSignIn.sharedInstance()?.signOut()
            Library.removeUserDefault()
            self.navigationController?.popViewController(animated: true)
            
        }catch let signoutError as NSError{
            print("Error Signout : \(signoutError)")
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(self.tableView, cellForRowAt: indexPath)
        
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
