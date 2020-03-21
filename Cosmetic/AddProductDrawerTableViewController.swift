//
//  AddProductDrawerTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class AddProductDrawerTableViewController: UITableViewController, DownloadCosmeticDeskListDelegate, DrawerCollectionDelegate {
    
    func onSuccess() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        cosmeticDeskList = item as! [CosmeticDeskModel]
        self.tableView.reloadData()
    }
    
    func itemCosmeticDeskFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    private var cosmeticDeskList: [CosmeticDeskModel] = []
    private var selectedItem: CosmeticDeskModel?
    var drawerId: String?
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        let downloadCosmeticDesk = DownloadCosmeticDeskList()
        downloadCosmeticDesk.delegate = self
        downloadCosmeticDesk.getCosmeticDeskByUserid(userId: userId!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cosmeticDeskList.count
    }

    //MARK: - Fetch item to cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addcollectionproductcell", for: indexPath) as! AddProductDrawerTableViewCell
        let item = cosmeticDeskList[indexPath.row]
        
        // Configure the cell...
        cell.titleTextView.text = item.product_name
        cell.descriptionTextView.text = item.product_description
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price ?? 0))
        cell.priceTextView.text = "Price : " + formattedPrice! + " Baht"
        let imageUrl = URL(string: item.product_img!)!
        cell.productImage.downloadImage(from: imageUrl)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doneButton.isEnabled = true
        let item = cosmeticDeskList[indexPath.row]
        selectedItem = item
    }

    @IBAction func tapDone(_ sender: Any) {
        let drawerCollection = DrawerCollection()
        drawerCollection.delegate = self
        drawerCollection.addToCollection(drawerId: drawerId!, deskId: selectedItem!.desk_id!)
    }

}
