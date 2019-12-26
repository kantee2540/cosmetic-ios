//
//  LoginViewController.swift
//  Cosmetic
//
//  Created by Omp on 25/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var usernameIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.setUnderLine()
        passwordTextField.setUnderLine()
        self.hideKeyboardWhenTappedAround()
        signinButton.roundedCorner()
        
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextField{
            usernameIcon.tintColor = UIColor.init(named: "main-font-color")
        }
        else if textField == passwordTextField{
            passwordIcon.tintColor = UIColor.init(named: "main-font-color")
        }
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField{
            usernameIcon.tintColor = UIColor.lightGray
        }
        else if textField == passwordTextField{
            passwordIcon.tintColor = UIColor.lightGray
        }
        textField.setUnderLine()
    }
}
