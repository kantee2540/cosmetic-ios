//
//  ChooseProductTopicTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 31/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class ChooseProductTopicTableViewController: UITableViewController, DownloadProductProtocol {
    func itemDownloaded(item: NSMutableArray) {
        productList = item as! [ProductModel]
        self.tableView.reloadData()
    }
    
    func itemDownloadFailed(error_mes: String) {
        let alert = UIAlertController(title: "Error", message: error_mes, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    var titleTopic: String?
    var descriptionTopic: String?
    private var productList: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? ChooseProductTopicTableViewCell
        let item = productList[indexPath.row]
        cell?.productName.text = item.product_name
        if item.product_img != ""{
            cell?.productImg.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
        }else{
            cell?.productImg.image = UIImage.init(named: "AppIcon")
        }
        // Configure the cell...
        return cell!
    }
    
}
