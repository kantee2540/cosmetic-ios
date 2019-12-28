//
//  ProfileTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 28/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet var profileTable: UITableView!
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var displaynameTextfield: UITextField!
    @IBOutlet weak var genderPicker: UITextField!
    @IBOutlet weak var birthdayPicker: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var genderList = ["Male", "Female", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createPickerView()
        createBirthdayPicker()
        dimissPickerView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - Picker view
    private func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderPicker.inputView = pickerView
    }
    
    //MARK: - Birthday picker
    private func createBirthdayPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        birthdayPicker.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        birthdayPicker.text = dateFormatter.string(from: sender.date)
    }
    
    private func dimissPickerView(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endEditing))
        button.tintColor = UIColor.init(named: "main-font-color")
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderPicker.inputAccessoryView = toolBar
        birthdayPicker.inputAccessoryView = toolBar
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    
    //MARK: - Setup view
    private func setupView(){
        firstnameTextfield.setUnderLine()
        lastnameTextfield.setUnderLine()
        displaynameTextfield.setUnderLine()
        genderPicker.setUnderLine()
        birthdayPicker.setUnderLine()
        saveButton.roundedCorner()
        
        firstnameTextfield.delegate = self
        lastnameTextfield.delegate = self
        displaynameTextfield.delegate = self
        genderPicker.delegate = self
        birthdayPicker.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 5
        }
        else{
            return 1
        }
    }
    
    @IBAction func tapSave(_ sender: Any) {
    }
    
}

extension ProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderPicker.text = genderList[row]
    }
    
}

extension ProfileTableViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setUnderLine()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = profileTable.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
}
