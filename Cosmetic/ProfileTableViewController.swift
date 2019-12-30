//
//  ProfileTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 28/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileTableViewController: UITableViewController, CollectUserdataDelegate, DownloadUserProtocol {

    @IBOutlet var profileTable: UITableView!
    @IBOutlet weak var firstnameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var displaynameTextfield: UITextField!
    @IBOutlet weak var genderPicker: UITextField!
    @IBOutlet weak var birthdayPicker: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var updateMode = false
    private var first = true
    private var genderList = ["Male", "Female", "Other"]
    var email: String?
    var uid: String?
    var birthday: String?
    private var saveError: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        setupView()
        createPickerView()
        createBirthdayPicker()
        dimissPickerView()
        
        if Auth.auth().currentUser != nil{
            let user = Auth.auth().currentUser
            if let user = user{
                email = user.email
                uid = user.uid
            }
        }else{
            
        }
    }
    
    //MARK: - Picker view
    private func createPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        genderPicker.inputView = pickerView
        if updateMode{
            genderPicker.text = UserDefaults.standard.string(forKey: ConstantUser.gender)
        }else{
            genderPicker.text = genderList[0]
        }
    }
    
    //MARK: - Birthday picker
    private func createBirthdayPicker(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.calendar = Calendar(identifier: .gregorian)
        birthdayPicker.inputView = datePicker
        handleDatePicker(sender: datePicker)
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if updateMode && first{
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd"
            dateFormat.locale = Locale.init(identifier: "en_GB")
            let dateObj = dateFormat.date(from: UserDefaults.standard.string(forKey: ConstantUser.birthday)!)
            dateFormat.dateFormat = "dd/MM/yyyy"
            birthdayPicker.text = dateFormat.string(from: dateObj!)
            birthday = birthdayForCollectData(date: dateObj!)
            first = false
        }else{
            birthdayPicker.text = dateFormatter.string(from: sender.date)
            birthday = birthdayForCollectData(date: sender.date)
        }
        
    }
    
    private func birthdayForCollectData(date :Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
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
        profileTable.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        if UserDefaults.standard.string(forKey: ConstantUser.firstName) != nil{
            //if update
            firstnameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.firstName)
            lastnameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.lastName)
            displaynameTextfield.text = UserDefaults.standard.string(forKey: ConstantUser.nickName)
            genderPicker.text = UserDefaults.standard.string(forKey: ConstantUser.gender)
            birthdayPicker.text = UserDefaults.standard.string(forKey: ConstantUser.birthday)
            saveButton.setTitle("Update", for: .normal)
            updateMode = true
        }else{
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && !saveError{
            return 5
        }
        else if section == 0 && saveError{
            return 6
        }
        else{
            return 1
        }
    }
    
    @IBAction func tapSave(_ sender: Any) {
        self.showSpinner(onView: self.view)
        let firstName = firstnameTextfield.text
        let lastName = lastnameTextfield.text
        let nickname = displaynameTextfield.text
        let myEmail = email
        let gender = genderPicker.text
        let myBirthday = birthday
        let myUid = uid
        
        let collectUserData = CollectUserdata()
        collectUserData.delegate = self
        
        if updateMode{
            collectUserData.updateUserdata(firstname: firstName!, lastName: lastName!, nickname: nickname!, email: myEmail!, gender: gender!, birthday: myBirthday!, uid: myUid!)
        }else{
            collectUserData.collectUserdata(firstname: firstName!, lastName: lastName!, nickname: nickname!, email: myEmail!, gender: gender!, birthday: myBirthday!, uid: myUid!)
        }
        
        
    }
    
    func insertDataSuccess() {
        self.removeSpinner()
        let downloadUser = DownloadUser()
        downloadUser.delegate = self
        downloadUser.getCurrentUserprofile(uid: uid!)
    }
    
    func insertDataFailed() {
        self.removeSpinner()
        saveError = true
        profileTable.reloadData()
    }
    
    func itemDownloadUser(item: UserModel) {
        UserDefaults.standard.set(item.firstName ?? nil, forKey: ConstantUser.firstName)
        UserDefaults.standard.set(item.lastName ?? "Not set", forKey: ConstantUser.lastName)
        UserDefaults.standard.set(item.nickname ?? "Not set", forKey: ConstantUser.nickName)
        UserDefaults.standard.set(item.email ?? "No set", forKey: ConstantUser.email)
        UserDefaults.standard.set(item.gender ?? "Other", forKey: ConstantUser.gender)
        UserDefaults.standard.set(item.birthday ?? "Not set", forKey: ConstantUser.birthday)
        
        if updateMode{
            self.navigationController?.popViewController(animated: true)
        }else{
            let successVc = self.storyboard?.instantiateViewController(withIdentifier: "registersuccess") as! RegisterSuccessViewController
            successVc.email = email
            self.navigationController?.pushViewController(successVc, animated: true)
        }
       
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
