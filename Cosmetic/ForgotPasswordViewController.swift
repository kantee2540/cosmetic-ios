//
//  ForgotPasswordViewController.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var sendEmailButton: CustomButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        sendEmailButton.roundedCorner()
        emailTextfield.setUnderLine()
        disableButton()
        emailTextfield.delegate = self
    }
    
    @IBAction func tapSendEmail(_ sender: Any) {
        let email = emailTextfield.text
        Auth.auth().sendPasswordReset(withEmail: email!, completion: { error in
            if let error = error{
                print(error)
                Library.displayAlert(targetVC: self, title: "Error", message: error.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Email has sent", message: "Please check inbox or junk mail in your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) -> Void in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
            
        })
    }
    
    private func disableButton(){
        sendEmailButton.backgroundColor = UIColor.systemGray
        sendEmailButton.isEnabled = false
    }
    
    private func enableButton(){
        sendEmailButton.backgroundColor = UIColor.init(named: "cosmetic-color")
        sendEmailButton.isEnabled = true
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0{
            enableButton()
        }else{
            disableButton()
        }
    }
}
