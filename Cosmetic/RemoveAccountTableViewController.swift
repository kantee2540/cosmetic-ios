//
//  RemoveAccountTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 21/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class RemoveAccountTableViewController: UITableViewController, UITextFieldDelegate, DeleteUserDelegate {
    func deleteUserSuccess() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func deleteUserFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
        loadActivity.isHidden = true
        removeButton.isEnabled = true
    }
    

    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    private var email: String?
    private var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email = UserDefaults.standard.string(forKey: ConstantUser.email)
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        emailTextfield.delegate = self
        loadActivity.isHidden = true
    }

    @IBAction func tapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapRemove(_ sender: Any) {
        loadActivity.isHidden = false
        removeButton.isEnabled = false
        let deleteUser = DeleteUser()
        deleteUser.delegate = self
        deleteUser.deleteUser()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == email{
            removeButton.isEnabled = true
        }else{
            removeButton.isEnabled = false
        }
    }
}
