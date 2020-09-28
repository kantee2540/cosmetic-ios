//
//  CameraCaptureViewController.swift
//  Cosmetic
//
//  Created by Omp on 26/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import PhotosUI
import AVFoundation
import CoreGraphics
import MLKit

class CameraCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, PHPickerViewControllerDelegate {
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var searchArray: Array<String>!
    var resultText: String = ""
    var isCapturing: Bool = false
    var isFlashOn: Bool = false

    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var livePreview: UIImageView!
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var controlContainer: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var topnavHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
            case 1136:
                //print("iPhone 5 or 5S or 5C")
                topnavHeight.constant = 55
            case 1334:
                //print("iPhone 6/6S/7/8")
                topnavHeight.constant = 55
            case 1920, 2208:
               //print("iPhone 6+/6S+/7+/8+")
                topnavHeight.constant = 55
            case 2436:
                //print("iPhone X/XS/11 Pro")
                topnavHeight.constant = 80
            case 2688:
                //print("iPhone XS Max/11 Pro Max")
                topnavHeight.constant = 80
            case 1792:
                //print("iPhone XR/ 11 ")
                topnavHeight.constant = 80
            default:
                //print("Unknown")
                topnavHeight.constant = 55
            }
        }
        
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupControlContainer()
        if isCapturing{
            startSession()
        }
    }
    
    private func setupControlContainer(){
        controlContainer.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(animated)
        stopSession()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLayoutSubviews() {
        videoPreviewLayer.frame = livePreview.frame
        if videoPreviewLayer != nil{
            if let connection = videoPreviewLayer.connection{
                let currentDevice = UIDevice.current
                let orientation = currentDevice.orientation
                let previewConnection = connection
                if previewConnection.isVideoOrientationSupported{
                    switch orientation {
                    case .portrait:
                        updatePreviewLayer(layer: previewConnection, orientation: .portrait)
                    case .landscapeRight:
                        updatePreviewLayer(layer: previewConnection, orientation: .landscapeLeft)
                    case .landscapeLeft:
                        updatePreviewLayer(layer: previewConnection, orientation: .landscapeRight)
                    case.portraitUpsideDown:
                        updatePreviewLayer(layer: previewConnection, orientation: .portraitUpsideDown)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation){
        layer.videoOrientation = orientation
        videoPreviewLayer.frame = self.livePreview.bounds
        stillImageOutput.connection(with: .video)?.videoOrientation = orientation
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Setup Camera
    
    private func setupCamera(){
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else{
                Library.displayAlert(targetVC: self, title: "Camera Error", message: "Unable to access back camera!")
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
            
            videoPreviewLayer.videoGravity = .resizeAspectFill
            livePreview.layer.addSublayer(videoPreviewLayer)
            
            captureSession.addInput(input)
            captureSession.addOutput(stillImageOutput)
            
            startSession()
            capturingPhoto()
        }
        
    }
    
    func startSession(){
        captureSession.startRunning()
    }
    
    func stopSession(){
        captureSession.stopRunning()
    }
    
    func toggleTorch(on: Bool){
        guard let device = AVCaptureDevice.default(for: .video) else{ return }
        if device.hasTorch{
            do{
                try device.lockForConfiguration()
                
                if on{
                    device.torchMode = .on
                    flashButton.setBackgroundImage(UIImage(systemName: "bolt.circle.fill"), for: .normal)
                    isFlashOn = true
                }else{
                    device.torchMode = .off
                    flashButton.setBackgroundImage(UIImage(systemName: "bolt.circle"), for: .normal)
                    isFlashOn = false
                }
                device.unlockForConfiguration()
            }catch{
                print("Torch could not be used")
            }
        }else{
            print("Torch not available")
        }
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Photo Capture
    @IBAction func tapCapture(_ sender: Any) {
        if isCapturing{
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            removeExistSubview()
        }else{
            searchFromImage()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else{
                return
            }

        let image = UIImage(data: imageData)
        updateImageView(with: image!)
        stopSession()
        afterCapturePhoto()
        
    }
    
    //MARK: - Pick image from library
    @IBAction func tapLibrary(_ sender: Any) {
        if #available(iOS 14, *){
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)

        }else{
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            navigationController?.present(pickerController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        removeExistSubview()
        picker.dismiss(animated: true)
        
        for result in results{
            let provider = result.itemProvider
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self){
                    image, error in
                    DispatchQueue.main.async {
                        self.updateImageView(with: image! as! UIImage)
                        self.afterCapturePhoto()
                        self.stopSession()
                    }
                }
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        removeExistSubview()
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        updateImageView(with: image)
        afterCapturePhoto()
        dismiss(animated: true, completion: nil)
    }
    
    private func updateImageView(with image: UIImage) {
        let orientation = UIDevice.current.orientation
        var scaledImageWidth: CGFloat = 0.0
        var scaledImageHeight: CGFloat = 0.0
            
        switch orientation {
        case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown:
            scaledImageWidth = self.photoPreviewImageView.bounds.size.width
            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
        case .landscapeLeft, .landscapeRight:
            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
            scaledImageHeight = self.photoPreviewImageView.bounds.size.height
        @unknown default:
            fatalError()
        }
        
      DispatchQueue.global(qos: .userInitiated).async {
        // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
        var scaledImage = image.scaledImage(
          with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
        )
        scaledImage = scaledImage ?? image
        guard let finalImage = scaledImage else { return }
        DispatchQueue.main.async {
          self.photoPreviewImageView.image = finalImage
        }
        self.textRecognizeOnDevice(image: finalImage)
      }
    }
    
    private func removeExistSubview(){
        for view in photoPreviewImageView.subviews{
            view.removeFromSuperview()
        }
    }
    
    //MARK: - Begin Search
    private func searchFromImage() {
        searchArray = Array()
        var startCount :Int = 0
        var charCount :Int = 0
        
//        let str = "ABCDEFGHIJK"
//        let s = str.index(str.startIndex, offsetBy: 1)
//        let e = str.index(str.startIndex, offsetBy: 5)
//        print(str[s..<e])
        
        while charCount < resultText.count {
            if resultText[resultText.index(resultText.startIndex, offsetBy: charCount)] == "\n" ||
                resultText[resultText.index(resultText.startIndex, offsetBy: charCount)] == " "{
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
    @IBAction func tapFlash(_ sender: Any) {
        if !isFlashOn{
            toggleTorch(on: true)
        }else{
            toggleTorch(on: false)
        }
    }
    
    @IBAction func tapRetake(_ sender: Any) {
        setupCamera()
        capturingPhoto()
    }
    
    private func capturingPhoto(){
        isCapturing = true
        photoPreviewImageView.isHidden = true
        captureButton.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
        tipLabel.text = "Arrange the cosmetic label to camera"
        retakeButton.isHidden = true
        flashButton.isHidden = false
    }
    
    private func afterCapturePhoto(){
        isCapturing = false
        DispatchQueue.main.async {
            self.photoPreviewImageView.isHidden = false
            self.captureButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            self.tipLabel.text = "Tap search to get result"
            self.retakeButton.isHidden = false
            self.flashButton.isHidden = true
            self.flashButton.setBackgroundImage(UIImage(systemName: "bolt.circle"), for: .normal)
        }
        
    }
    
    //MARK: - Firebase text processing
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = photoPreviewImageView.image else { return CGAffineTransform() }
        let imageViewWidth = photoPreviewImageView.frame.size.width
        let imageViewHeight = photoPreviewImageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
    
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale =
          (imageViewAspectRatio > imageAspectRatio)
          ? imageViewHeight / imageHeight : imageViewWidth / imageWidth
    
        // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size   of the
        // image view by maintaining the aspect ratio. Multiple by `scale` to get image's   original size.
        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
    
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    public static func addRectangle(_ rectangle: CGRect, to view: UIView, color: UIColor) {
        guard !rectangle.isNaN() else { return }
        let rectangleView = UIView(frame: rectangle)
        rectangleView.layer.cornerRadius = Constants.rectangleViewCornerRadius
        rectangleView.alpha = Constants.rectangleViewAlpha
        rectangleView.backgroundColor = color
        view.addSubview(rectangleView)
    }
    
    private enum Constants {
      static let rectangleViewAlpha: CGFloat = 0.3
      static let rectangleViewCornerRadius: CGFloat = 5.0
    }

    
    func textRecognizeOnDevice(image :UIImage?){
        guard let image = image else { return }
        
        let textRecognizer = TextRecognizer.textRecognizer()
        
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        textRecognizer.process(visionImage) { [self] result, error in
          guard error == nil, let result = result else {
            // Error handling
            self.resultText = ""
            return
          }
            
          // Recognized text
            print("\(result.text)\n")
            self.resultText = "\(result.text)\n"
            for block in result.blocks{
                // Lines.
                for line in block.lines {
                    let transformedRect = line.frame.applying(self.transformMatrix())
                    CameraCaptureViewController.addRectangle(
                      transformedRect,
                        to: self.photoPreviewImageView,
                      color: .orange
                    )
                    
                }
            }
            
        }
        
    }
}

extension CGRect {
  /// Returns a `Bool` indicating whether the rectangle has any value that is `NaN`.
  func isNaN()  -> Bool {
    return origin.x.isNaN || origin.y.isNaN || width.isNaN || height.isNaN
  }
}
