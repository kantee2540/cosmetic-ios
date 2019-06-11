//
//  CameraViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import SafariServices

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Search by Camera"
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
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
