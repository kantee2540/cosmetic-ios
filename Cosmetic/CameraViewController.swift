//
//  CameraViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision
import AVFoundation
import CoreML

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let cameraRunning = false
    var resultOutputText: String!
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var imageOutput: AVCapturePhotoOutput!
    let videoOutput = AVCaptureVideoDataOutput()
    let sampleBufferQueue = DispatchQueue.global(qos: .userInteractive)
    
    @IBOutlet weak var cameraView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        self.tabBarController?.navigationItem.title = "Search by Camera"
        
        let layer = CALayer()
        layer.contents = UIImage(named: "item1")?.cgImage
        cameraView.layer.addSublayer(layer)
        
    }

    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("Output processed")
        guard let imageData = photo.fileDataRepresentation()
            else{
                return
        }
        //let image = UIImage(data: imageData)!
        
//        let vc = CameraResultViewController(nibName: "CameraResultViewController", bundle: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
//        vc.imageResult = image
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        onStartCamera()
        
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
            
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resize
            cameraView.layer.addSublayer(videoPreviewLayer)
                
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
                
            captureSession.addOutput(videoOutput)
            
                
            onStartCamera()
            
            
        }catch let error{
            print("Error Camera!! ==> \(error)")
        }
        
        
        
    }
    @IBAction func cameraClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraResult") as! cameraResultTableViewController
        vc.keyword = resultOutputText ?? ""
        navigationController?.pushViewController(vc , animated: true)
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
    
//    @IBAction func takePhoto(_ sender: Any) {
//        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        //imageOutput.capturePhoto(with: settings, delegate: self)
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        videoOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
//
//        print("CLICKED!")
//    }
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var resultTextView: UITextView!
    
    
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let cameraPosition = AVCaptureDevice.Position.back
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )
        let image = VisionImage(buffer: sampleBuffer)
        image.metadata = metadata

        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                self.resultTextView.text = "Could not found!"
                return
            }

            //let resultText = result.text
            for block in result.blocks{
                for line in block.lines{
                    for element in line.elements{
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.resultTextView.text = element.text
                        })
                    }
                }
                
            }
        }
    }
    
    
    private func addFrameView(featureFrame: CGRect, imageSize: CGSize, viewFrame: CGRect, text: String? = nil){
        
    }
    
    
    func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
        ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
        
    }

}
