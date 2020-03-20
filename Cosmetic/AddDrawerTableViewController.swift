//
//  AddDrawerTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class AddDrawerTableViewController: UITableViewController, DrawerDelegate, UITextFieldDelegate {
    
    private var userId :String?
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet var addDrawerTable: UITableView!
    @IBOutlet weak var drawerNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    func itemAddSuccess() {
        loadingActivity.isHidden = true
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func itemAddFailed() {
        loadingActivity.isHidden = true
        doneButton.isEnabled = true
        Library.displayAlert(targetVC: self, title: "Error", message: "Add Drawer item failed!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        addDrawerTable.delegate = self
        addDrawerTable.dataSource = self
        drawerNameTextField.delegate = self
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

    @IBAction func tapDone(_ sender: Any) {
        loadingActivity.isHidden = false
        doneButton.isEnabled = false
        let drawerName = drawerNameTextField.text!
        let addDrawer = Drawer()
        addDrawer.delegate = self
        addDrawer.addDrawer(userid: userId!, drawer_name: drawerName)
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
    }

}
