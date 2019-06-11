//
//  RegisterViewController.swift
//  Cosmetic
//
//  Created by Omp on 28/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    //URL TO DATABASE
    var DB_URL:String = "http://192.168.1.173/webService/createuser.php"

    @IBOutlet weak var firstnametext: UITextField!
    @IBOutlet weak var lastnametext: UITextField!
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var registerbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        firstnametext.tag = 0
        lastnametext.tag = 1
        emailtext.tag = 2
        firstnametext.delegate = self
        lastnametext.delegate = self
        emailtext.delegate = self
        
        firstnametext.layer.cornerRadius = 5
        lastnametext.layer.cornerRadius = 5
        registerbtn.layer.cornerRadius = 10
        
        
    }

    //Click register Button
    @IBAction func registerbtn(_ sender: UIButton) {
        gotoRegister()
        
    }
    
    func gotoRegister(){
        //alert controller
        let alert = UIAlertController(title: "Cannot leave form blank", message: "Please enter your information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        
        if(firstnametext.text != "" && lastnametext.text != "" && emailtext.text != ""){
            
            var request = URLRequest(url: URL(string: DB_URL)!)
            request.httpMethod = "POST"
            
            //get from UI TextField
            let firstname = firstnametext.text
            let lastname = lastnametext.text
            let email = emailtext.text
            
            let postParameters = "firstname="+firstname!+"&lastname="+lastname!+"&email="+email!
            request.httpBody = postParameters.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request){
                data, response, error in
                guard let data = data, error == nil else{
                    print("error=\(String(describing: error))")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200{
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
            }
            task.resume()
            //After finished insert row to database
            gotonextPage()
        }
        else{
            
            self.present(alert, animated: true)
        }
    }
    
    func gotonextPage(){
        let successVC = SuccessViewController(nibName: "SuccessViewController", bundle: nil)
        successVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(successVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Next text field
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    

    
    
}
