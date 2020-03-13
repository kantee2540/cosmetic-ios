//
//  NoLoginViewController.swift
//  Cosmetic
//
//  Created by Omp on 24/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class NoLoginViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signinButton.makeRoundedView()
        // Do any additional setup after loading the view.
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
