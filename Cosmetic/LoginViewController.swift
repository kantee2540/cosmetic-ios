//
//  LoginViewController.swift
//  Cosmetic
//
//  Created by Omp on 22/3/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var registerbtn: UIButton!
    
    var username:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //ปุ่ม โค้งมน
        loginView.layer.cornerRadius = 10
        loginbtn.layer.cornerRadius = 5
        registerbtn.layer.cornerRadius = 5
        
    }
    
    //ซ่อนกับแสดงแถบด้านบน
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //คลิก Return แล้วออกจาก TextField
        //Next text field
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
