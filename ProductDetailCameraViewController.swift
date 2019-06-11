//
//  ProductDetailCameraViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class ProductDetailCameraViewController: UIViewController {

    @IBOutlet var resultView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    @IBAction func clickDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
