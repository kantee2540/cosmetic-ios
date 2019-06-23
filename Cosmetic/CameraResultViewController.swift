//
//  CameraResultViewController.swift
//  Cosmetic
//
//  Created by Omp on 13/6/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase

class CameraResultViewController: UIViewController {


    var imageResult :UIImage!
    var textResult :String!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var textViewResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewImage.image = imageResult
        textProcessing()
        // Do any additional setup after loading the view.
    }
    
    func textProcessing(){
        let vision = Vision.vision()
        let recognizer = vision.onDeviceTextRecognizer()
        let visionImage = VisionImage(image: imageResult)
        
        self.showSpinner(onView: self.view)
        recognizer.process(visionImage)  { result, error in
            guard error == nil, let result = result else{
                return
            }
            
            self.textResult = result.text
            
            
            print("Text that detected ===> " + result.text)
        }
        textViewResult.text = textResult
        
        self.removeSpinner()
    }

}

var vSpinnerCamera :UIView?
extension CameraResultViewController{
    func showSpinner(onView :UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinnerCamera = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinnerCamera?.removeFromSuperview()
            vSpinnerCamera = nil
        }
    }
}
