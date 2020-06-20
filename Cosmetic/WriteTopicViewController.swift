//
//  WriteTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 17/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class WriteTopicViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        detailTextView.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gochooseimage"{
            let destination = segue.destination as? ChooseImageViewController
            destination?.titleTopic = titleTextField.text
            destination?.descriptionTopic = detailTextView.text
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkEnableButton()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        checkEnableButton()
    }
    
    private func checkEnableButton(){
        if titleTextField.text!.count > 0 && detailTextView.text.count > 0{
            nextButton.isEnabled = true
        }else{
            nextButton.isEnabled = false
        }
    }
}
