//
//  RegisterSuccessViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class RegisterSuccessViewController: UIViewController {

    var email: String!
    @IBOutlet weak var successEmail: UILabel!
    @IBOutlet weak var gobackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView(){
        successEmail.text = email
        self.navigationItem.setHidesBackButton(true, animated: true)
        gobackButton.roundedCorner()
    }
    
    @IBAction func tapGoback(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
