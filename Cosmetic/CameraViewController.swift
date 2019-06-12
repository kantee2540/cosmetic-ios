//
//  CameraViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class CameraViewController: UIViewController {
    
    let vision = Vision.vision()
    let cameraRunning = false
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imageOutput: AVCapturePhotoOutput!
    
    @IBOutlet weak var cameraView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        
        let recognizer = vision.onDeviceTextRecognizer()
        let image :UIImage = UIImage(named: "item2")!
        let visionImage = VisionImage(image: image)
        
        recognizer.process(visionImage)  { result, error in
            guard error == nil, let result = result else{
                return
            }
            
            print("Text that detected ===> " + result.text)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Search by Camera"
        
        videoPreviewLayer!.frame = cameraView.bounds
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        onStopCamera()
    }
    
    func setupCamera(){
        captureSession = AVCaptureSession()
        //captureSession?.sessionPreset = .high
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else{
                print("Unable to access back Camera!!")
                return
        }
        
        do{
            let input = try AVCaptureDeviceInput(device: backCamera)
            imageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(imageOutput as AVCaptureOutput){
                captureSession?.addInput(input)
                captureSession.addOutput(imageOutput)
                
                setupLivePreview()
                
                onStartCamera()
            }
            
            
        }catch let error{
            print("Error Camera!! ==> \(error)")
        }
        
        
        
    }
    func onStartCamera(){
        captureSession.startRunning()
    }
    func onStopCamera(){
        captureSession.stopRunning()
    }
    
    
    func setupLivePreview(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        cameraView.layer.addSublayer(videoPreviewLayer)
        
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
