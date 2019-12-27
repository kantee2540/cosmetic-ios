//
//  RegisterViewController.swift
//  Cosmetic
//
//  Created by Omp on 26/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield()
        // Do any additional setup after loading the view.
    }
    
    private func setupTextfield(){
        emailTextfield.setUnderLine()
        passwordTextfield.setUnderLine()
        confirmTextfield.setUnderLine()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        confirmTextfield.delegate = self
        self.hideKeyboardWhenTappedAround()
        registerButton.roundedCorner()
    }
    
    private func createAccount(email:String, password:String){
        Auth.auth().createUser(withEmail: email, password: password){
            (user, error) in if let error = error{
                print("CREATE USER ERROR = \(error)")
            }
        }
    }
    
    private func checkPasswordPolicy(){
        if (passwordTextfield.text == confirmTextfield.text)
            && (passwordTextfield.text != "" && confirmTextfield.text != "" && emailTextfield.text != ""){
            print("OK")
            
        }else{
            if passwordTextfield.text != confirmTextfield.text{
                errorMessage.text = "Password and Confirm Password not matched. Please try again."
            }
            else if passwordTextfield.text == "" && confirmTextfield.text == "" && emailTextfield.text == ""{
                errorMessage.text = "Do not leave the text field blank. Please fill information."
            }
            else{
                errorMessage.text = "Try again"
            }
        }
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapRegister(_ sender: Any) {
        checkPasswordPolicy()
    }
}

extension RegisterViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
}
