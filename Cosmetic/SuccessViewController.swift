//
//  SuccessViewController.swift
//  Cosmetic
//
//  Created by Omp on 29/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    @IBOutlet weak var backtoLoginbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Completed"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        backtoLoginbtn.layer.cornerRadius = 10
        
        
    }

    
    @IBAction func clickBacktoLogin(_ sender: Any) {
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
