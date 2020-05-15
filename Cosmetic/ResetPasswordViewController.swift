//
//  ResetPasswordViewController.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sendEmailButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendEmailButton.makeRoundedView()
        
        let user = Auth.auth().currentUser
        emailLabel.text = user?.email
        
    }
    
    @IBAction func tapsendEmail(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailLabel.text!, completion: { error in
            
            if let error = error{
                Library.displayAlert(targetVC: self, title: "Error", message: error.localizedDescription)
                return
            }
            
            let alert = UIAlertController(title: "Email has sent", message: "Please check your inbox or junk Email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                self.navigationController?.popViewController(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        })
    }

}
