//
//  SetPasswordTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class SetPasswordTableViewController: UITableViewController {
    
    @IBOutlet weak var registerButton: CustomButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var warnLabel: UILabel!
    private var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.makeRoundedView()
        passwordTextfield.setUnderLine()
        confirmPasswordTextfield.setUnderLine()
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
        
        user = Auth.auth().currentUser
        emailLabel.text = user.email
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func tapRegister(_ sender: Any) {
        
        if (passwordTextfield.text == confirmPasswordTextfield.text) && (passwordTextfield.text!.count >= 8){
           
           let email = user?.email
           let password = passwordTextfield.text
           let credential = EmailAuthProvider.credential(withEmail: email!, password: password!)
           user?.link(with: credential, completion: {authResult, error in
               if let error = error{
                   Library.displayAlert(targetVC: self, title: "Error", message: error.localizedDescription)
                   return
               }
               
               let alert = UIAlertController(title: "Link with E-mail and Password", message: "Now you can login with your E-mail and Password", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                   self.navigationController?.popViewController(animated: true)
               }))
               self.present(alert, animated: true, completion: nil)
           })
           
       }else{
           warnLabel.isHidden = false
           if passwordTextfield.text != confirmPasswordTextfield.text{
               warnLabel.text = "Password and confirm password not match"
           }else if passwordTextfield.text!.count < 8{
               warnLabel.text = "Password must have 8 characters"
           }else{
               warnLabel.text = "Please fill all information"
           }
       }
        
    }
}

extension SetPasswordTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.tableView.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text!.count >= 8{
            textField.setGreenUnderline()
        }else{
            textField.setUnderLine()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
}
