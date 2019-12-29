//
//  RegisterTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterTableViewController: UITableViewController {

    @IBOutlet var formTable: UITableView!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    private var showError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Register"
        formTable.delegate = self
        setupView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setupView(){
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmPasswordTextfield.delegate = self
        emailTextfield.setUnderLine()
        passwordTextfield.setUnderLine()
        confirmPasswordTextfield.setUnderLine()
        registerButton.roundedCorner()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func createAccount(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password){
            (user, error) in
            if let error = error{
                print("CREATE USER ERROR = \(error)")
                self.errorMessage.text = error.localizedDescription
                self.showError = true
                self.formTable.reloadData()
                self.removeSpinner()
                return
            }
            print("CREATED!")
            let profileVc = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileTableViewController
            self.removeSpinner()
            self.navigationController?.pushViewController(profileVc, animated: true)
        }
    }
    
    private func checkPasswordPolicy(){
        if (passwordTextfield.text == confirmPasswordTextfield.text)
            && (passwordTextfield.text != "" && confirmPasswordTextfield.text != "" && emailTextfield.text != "")
            && (passwordTextfield.text!.count >= 8){
            //Create account
            createAccount(email: emailTextfield.text!, password: passwordTextfield.text!)
            
        }
        else{
            showError = true
            if passwordTextfield.text != confirmPasswordTextfield.text{
                errorMessage.text = "Password and Confirm Password not matched. Please try again."
            }
            else if passwordTextfield.text == "" || confirmPasswordTextfield.text == "" || emailTextfield.text == ""{
                errorMessage.text = "Do not leave the text field blank. Please fill information."
            }
            else if passwordTextfield.text!.count < 8{
                errorMessage.text = "Password must have minimum 8 characters."
            }
            else{
                errorMessage.text = "Try again"
            }
            formTable.reloadData()
            self.removeSpinner()
        }
    }
    @IBAction func tapRegister(_ sender: Any) {
        showSpinner(onView: self.view)
        checkPasswordPolicy()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            if showError{
                return 5
            }else{
                return 4
            }
        }else if section == 1{
            return 1
        }
        return 0
    }

}

extension RegisterTableViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextfield || textField == confirmPasswordTextfield{
        // Underlined green when greater than 8 characters
            if textField.text!.count >= 8{
                textField.setGreenUnderline()
            }else{
                textField.setUnderLine()
            }
        }else{
            textField.setUnderLine()
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == passwordTextfield || textField == confirmPasswordTextfield{
        // Underlined green when greater than 8 characters
            if textField.text!.count >= 8{
                textField.setGreenUnderline()
            }else{
                textField.setUnderLine()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = formTable.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}
