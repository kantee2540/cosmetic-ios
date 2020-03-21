//
//  ChooseDrawerTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class ChooseDrawerTableViewController: UITableViewController, DownloadDrawerDelegate, DrawerCollectionDelegate {
    func onSuccess() {
        self.navigationController?.popViewController(animated: true)
        removeSpinner()
    }
    
    func itemDrawerDownloaded(item: NSMutableArray) {
        drawerList = item as! [DrawerModel]
        self.tableView.reloadData()
        removeSpinner()
    }
    
    func itemDrawerFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    private var drawerList: [DrawerModel] = []
    private var selectedItem :DrawerModel?
    var deskId: String?
    @IBOutlet var okButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        showSpinner(onView: self.view)
        let downloadDrawer = DownloadDrawer()
        downloadDrawer.delegate = self
        downloadDrawer.downloadDrawer(userid: userId!)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return drawerList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawercell", for: indexPath)
        let item = drawerList[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = item.drawer_name
        cell.detailTextLabel?.text = item.countitem! + " Cosmetics"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        okButton.isEnabled = true
        let item = drawerList[indexPath.row]
        selectedItem = item
    }
    

    @IBAction func tapOK(_ sender: Any) {
        showSpinner(onView: self.view)
        let drawerCollection = DrawerCollection()
        drawerCollection.delegate = self
        drawerCollection.addToCollection(drawerId: selectedItem!.drawer_id!, deskId: deskId!)
    }

}
