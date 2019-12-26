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
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.setUnderLine()
        passwordTextField.setUnderLine()
        self.hideKeyboardWhenTappedAround()
        signinButton.roundedCorner()
        
    }

}

extension LoginViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
}
