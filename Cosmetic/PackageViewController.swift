//
//  PackageViewController.swift
//  Cosmetic
//
//  Created by Omp on 4/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var codeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        codeField.delegate = self
        codeField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        codeField.setUnderLine()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Package"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
