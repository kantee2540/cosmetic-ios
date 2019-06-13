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

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let vision = Vision.vision()
    let cameraRunning = false
    var resultOutputText: String!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imageOutput: AVCapturePhotoOutput!
    
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var captureButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Output processed")
        guard let imageData = photo.fileDataRepresentation()
            else{
                return
        }
        let image = UIImage(data: imageData)!
        textProcessing(tookPhoto: image)
        
        captureButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Search by Camera"
        
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
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = .resizeAspect
                cameraView.layer.addSublayer(videoPreviewLayer)
                
                onStartCamera()
            }
            
            
        }catch let error{
            print("Error Camera!! ==> \(error)")
        }
        
        
        
    }
    func onStartCamera(){
        captureSession.startRunning()
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.cameraView.bounds
        }
    }
    func onStopCamera(){
        captureSession.stopRunning()
    }
    
    func textProcessing(tookPhoto: UIImage){
        let recognizer = vision.onDeviceTextRecognizer()
        let image :UIImage = tookPhoto
        let visionImage = VisionImage(image: image)
        
        recognizer.process(visionImage)  { result, error in
            guard error == nil, let result = result else{
                return
            }
            
            self.resultOutputText = result.text
            print("Text that detected ===> " + result.text)
        }
        
        
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        imageOutput.capturePhoto(with: settings, delegate: self)
        
        print("CLICKED!")
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
