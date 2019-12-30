//
//  LoginViewController.swift
//  Cosmetic
//
//  Created by Omp on 25/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, DownloadUserProtocol {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var usernameIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var incorrectLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        incorrectLabel.text = ""
        usernameTextField.setUnderLine()
        passwordTextField.setUnderLine()
        self.hideKeyboardWhenTappedAround()
        signinButton.roundedCorner()
    }
    
    @IBAction func tapSignin(_ sender: Any) {
        signinProcess()
    }
    
    private func signinProcess(){
        self.showSpinner(onView: self.view)
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!){ [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error{
                print("SIGNIN ERROR = \(error)")
                self?.incorrectLabel.isHidden = false
                self?.incorrectLabel.text = error.localizedDescription
                self?.removeSpinner()
                return
            }
            print("LOGGEDIN!")
            let downloadUser = DownloadUser()
            downloadUser.delegate = self
            downloadUser.getCurrentUserprofile(uid: (authResult?.user.uid)!)
            
        }
    }
    
    func itemDownloadUser(item: UserModel) {
        UserDefaults.standard.set(item.firstName ?? nil, forKey: ConstantUser.firstName)
        UserDefaults.standard.set(item.lastName ?? "Not set", forKey: ConstantUser.lastName)
        UserDefaults.standard.set(item.nickname ?? "Not set", forKey: ConstantUser.nickName)
        UserDefaults.standard.set(item.email ?? "No set", forKey: ConstantUser.email)
        UserDefaults.standard.set(item.gender ?? "Other", forKey: ConstantUser.gender)
        UserDefaults.standard.set(item.birthday ?? "Not set", forKey: ConstantUser.birthday)
        self.removeSpinner()
        self.navigationController?.popToRootViewController(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
}
