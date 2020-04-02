//
//  WriteTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 17/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class WriteTopicViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gochooseimage"{
            let destination = segue.destination as? ChooseImageViewController
            destination?.titleTopic = titleTextField.text
            destination?.descriptionTopic = detailTextView.text
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0{
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
        }
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
