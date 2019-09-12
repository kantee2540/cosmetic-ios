//
//  CameraCaptureViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/8/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase

class CameraCaptureViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var imageResult: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        imageResult.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        firebaseRecongnize(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
    }
    
    func firebaseRecongnize(image: UIImage){
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        DispatchQueue.global(qos: .userInitiated).async {
            while true {
                let image = VisionImage(image: image)
                textRecognizer.process(image) { result, error in
                    guard error == nil, let result = result else {
                        self.resultTextView.text = "Could not found!"
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.resultTextView.text = result.text
                    }
    
                }
            }
        }
        
    }

    @IBAction func doneButton(_ sender: Any) {
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
