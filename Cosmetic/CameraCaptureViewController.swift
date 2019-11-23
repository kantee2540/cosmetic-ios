//
//  CameraCaptureViewController.swift
//  Cosmetic
//
//  Created by Omp on 26/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class CameraCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
    
    lazy var vision = Vision.vision()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var outputImage: UIImage!
    var searchArray: Array<String>!
    var resultText: String = ""
    var isCapturing: Bool = false

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    @IBOutlet weak var retakeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isCapturing{
            self.captureSession.startRunning()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Setup Camera
    
    private func setupCamera(){
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else{
                print("Unable to access back camera!")
                return
            }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do{
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        stillImageOutput = AVCapturePhotoOutput()
        if captureSession!.canAddInput(input) && captureSession!.canAddOutput(stillImageOutput!){
            captureSession.addInput(input)
            captureSession.addOutput(stillImageOutput)
            setupLivePreview()
        }
        
    }
    
    private func setupLivePreview(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.videoGravity = .resizeAspectFill
        photoPreviewImageView.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
        capturingPhoto()
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.photoPreviewImageView.bounds
        }
        
    }
    
    // MARK: - Photo Capture
    @IBAction func tapCapture(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else{
                return
            }
        
        let image = UIImage(data: imageData)
        outputImage = image
        captureSession.stopRunning()
        photoPreviewImageView.layer.sublayers = nil
        photoPreviewImageView.image = outputImage
        afterCapturePhoto()
        textRecognizeOnDevice(image: outputImage)
        
    }
    
    //MARK: - Pick image from library
    @IBAction func tapLibrary(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        navigationController?.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        outputImage = image
        captureSession.stopRunning()
        photoPreviewImageView.image = outputImage
        photoPreviewImageView.layer.sublayers = nil
        afterCapturePhoto()
        textRecognizeOnDevice(image: outputImage)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Begin Search
    @IBAction func tapSearch(_ sender: Any) {
        searchArray = Array()
        var startCount :Int = 0
        var charCount :Int = 0
        
//        let str = "ABCDEFGHIJK"
//        let s = str.index(str.startIndex, offsetBy: 1)
//        let e = str.index(str.startIndex, offsetBy: 5)
//        print(str[s..<e])
        
        while charCount < resultText.count {
            if resultText[resultText.index(resultText.startIndex, offsetBy: charCount)] == "\n"{
                let startIndex = resultText.index(resultText.startIndex, offsetBy: startCount)
                let endIndex = resultText.index(resultText.startIndex, offsetBy: charCount)
                
                let exText = resultText[startIndex..<endIndex]
                searchArray.append(String(exText.lowercased()))
                startCount = charCount + 1
            }
            charCount += 1
        }
        
        let infoVc = storyboard?.instantiateViewController(withIdentifier: "cameraResult") as? cameraResultTableViewController
        if searchArray.count != 0{
            infoVc!.capturedWord = searchArray
        }
        navigationController?.pushViewController(infoVc!, animated: true)
    }
    
    @IBAction func tapRetake(_ sender: Any) {
        setupCamera()
        capturingPhoto()
    }
    
    private func capturingPhoto(){
        isCapturing = true
        captureButton.isHidden = false
        searchButton.isHidden = true
        retakeButton.isHidden = true
    }
    
    private func afterCapturePhoto(){
        isCapturing = false
        captureButton.isHidden = true
        searchButton.isHidden = false
        retakeButton.isHidden = false
    }
    
    //MARK: - Firebase text processing
    func textRecognizeOnDevice(image :UIImage?){
        guard let image = image else { return }
        
        let onDeviceTextRecognizer = vision.onDeviceTextRecognizer()
        
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = CameraCaptureViewController.visionImageOrientation(from: image.imageOrientation)
        
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetadata
        
        textProcessing(visionImage, with: onDeviceTextRecognizer)    }
    
    func textProcessing(_ visionImage: VisionImage, with textRecognizer: VisionTextRecognizer?){
        
        textRecognizer?.process(visionImage){
            result, error in guard error == nil, let textResult = result else{
                print(error as Any)
                self.resultText = ""
                return
            }
            
            for block in textResult.blocks{
                for line in block.lines{
                    for element in line.elements{
                        
                    }
                }
                
            }
            
            print("\(textResult.text)\n")
            self.resultText = "\(textResult.text)\n"
        }
        
    }
    
    public static func visionImageOrientation(
      from imageOrientation: UIImage.Orientation
      ) -> VisionDetectorImageOrientation {
        switch imageOrientation {
          case .up:
            return .topLeft
          case .down:
            return .bottomRight
          case .left:
            return .leftBottom
          case .right:
            return .rightTop
          case .upMirrored:
            return .topRight
          case .downMirrored:
            return .bottomLeft
          case .leftMirrored:
            return .leftTop
          case .rightMirrored:
            return .rightBottom
        }
    }
}
