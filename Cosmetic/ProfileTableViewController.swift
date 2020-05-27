//
//  ProfileTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 28/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileTableViewController: UITableViewController, CollectUserdataDelegate, DownloadUserProtocol {

    @IBOutlet var profileTable: UITableView!
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var displaynameTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var updateMode = false
    private var first = true
    private var genderList = ["Male", "Female", "Other"]
    var email: String?
    var uid: String?
    var birthday: String?
    private var saveError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        setupView()
        
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user{
                email = user.email
                uid = user.uid
                if let display = user.displayName{
                    displaynameTextfield.text = display
                }
            }
        }else{
            
        }
    }
    
    private func birthdayForCollectData(date :Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    //MARK: - Setup view
    private func setupView(){
        firstnameTextfield.setUnderLine()
        lastnameTextfield.setUnderLine()
        displaynameTextfield.setUnderLine()
        saveButton.roundedCorner()
        
        firstnameTextfield.delegate = self
        lastnameTextfield.delegate = self
        displaynameTextfield.delegate = self
        profileTable.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        if UserDefaults.standard.string(forKey: ConstantUser.firstName) != nil{
            //if update
            firstnameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.firstName)
            lastnameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.lastName)
            displaynameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.nickName)
            saveButton.setTitle("Update", for: .normal)
            updateMode = true
        }else{
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && !saveError{
            return 3
        }
        else if section == 0 && saveError{
            return 4
        }
        else{
            return 1
        }
    }
    
    @IBAction func tapSave(_ sender: Any) {
        self.showSpinner(onView: self.view)
        let firstName = firstnameTextfield.text
        let lastName = lastnameTextfield.text
        let nickname = displaynameTextfield.text
        let myEmail = email
        let myUid = uid
        
        let collectUserData = CollectUserdata()
        collectUserData.delegate = self
        
        if updateMode{
            collectUserData.updateUserdata(firstname: firstName!, lastName: lastName!, nickname: nickname!, email: myEmail!, uid: myUid!)
        }else{
            collectUserData.collectUserdata(firstname: firstName!, lastName: lastName!, nickname: nickname!, email: myEmail!, uid: myUid!)
        }
        
        
    }
    
    func insertDataSuccess() {
        self.removeSpinner()
        let downloadUser = DownloadUser()
        downloadUser.delegate = self
        downloadUser.getCurrentUserprofile(uid: uid!)
    }
    
    func insertDataFailed() {
        self.removeSpinner()
        saveError = true
        
        if !updateMode{
            let alert = UIAlertController(title: "Error", message: "Can't signup please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                let user = Auth.auth().currentUser
                user?.delete(completion: { error in
                    if error != nil{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    else{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                })
                self.profileTable.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Can't edit please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                self.navigationController?.popToRootViewController(animated: true)
                self.profileTable.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateProfileSuccess(imageURL: String) {
        
    }
    
    func itemDownloadUser(item: UserModel) {
        Library.setUserDefault(user: item)
        
        if updateMode{
            self.navigationController?.popViewController(animated: true)
        }else{
            let successVc = self.storyboard?.instantiateViewController(withIdentifier: "registersuccess") as! RegisterSuccessViewController
            successVc.email = email
            self.navigationController?.pushViewController(successVc, animated: true)
        }
       
    }
    
    func itemUserError(error: String) {
        if updateMode{
            Library.displayAlert(targetVC: self, title: "Error", message: "Can't update profile")
        }else{
            Library.displayAlert(targetVC: self, title: "Error", message: "Can't signup please try again")
            let user = Auth.auth().currentUser
            user?.delete(completion: { error in
                if error != nil{
                    
                }
                else{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
    }
    
}

extension ProfileTableViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = profileTable.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
}
