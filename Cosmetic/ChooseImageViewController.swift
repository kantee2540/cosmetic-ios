//
//  ChooseImageViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class ChooseImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    
    var titleTopic: String?
    var descriptionTopic: String?
    private var selected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goselectproduct"{
            let destination = segue.destination as? ChooseProductTopicTableViewController
            destination?.titleTopic = titleTopic
            destination?.descriptionTopic = descriptionTopic
            destination?.selectedImage = selectedImage.image
            destination?.isSelectedCustomImage = selected
        }
    }
    
    @IBAction func tapChooseImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        
        let action = UIAlertController(title: "Select Image", message: "", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (UIAlertAction) in
            pickerController.sourceType = .camera
            self.navigationController?.present(pickerController, animated: true, completion: nil)
        }))
        action.addAction(UIAlertAction(title: "Library", style: .default, handler: {
            (UIAlertAction) in
            pickerController.sourceType = .photoLibrary
            self.navigationController?.present(pickerController, animated: true, completion: nil)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (UIAlertAction) in
        }))
        
        if let popoverController = action.popoverPresentationController{
            popoverController.sourceView = chooseButton
            popoverController.sourceRect = chooseButton.bounds
        }
        
        self.present(action, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage.image = image
        selected = true
        dismiss(animated: true, completion: nil)
    }
}
