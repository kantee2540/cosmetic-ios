//
//  NotificationViewController.swift
//  Cosmetic
//
//  Created by Omp on 9/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Notifications"
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
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
