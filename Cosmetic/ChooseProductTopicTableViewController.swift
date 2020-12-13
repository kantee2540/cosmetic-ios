//
//  ChooseProductTopicTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 31/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol ChooseProductDelegate {
    func finshedSelectItem(item: [CosmeticDeskModel])
}

class ChooseProductTopicTableViewController: UITableViewController, DownloadCosmeticDeskListDelegate, UISearchBarDelegate {
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        productList = item as! [CosmeticDeskModel]
        self.tableView.reloadData()
    }
    
    func itemCosmeticDeskFailed(error error_mes: String) {
        let alert = UIAlertController(title: "Error", message: error_mes, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private var productList: [CosmeticDeskModel] = []
    private var selectedProduct: [CosmeticDeskModel] = []
    
    var titleTopic: String?
    var descriptionTopic: String?
    var selectedImage: UIImage?
    var isSelectedCustomImage: Bool?
    var delegate: ChooseProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let downloadProduct = DownloadCosmeticDeskList()
        downloadProduct.delegate = self
        downloadProduct.getCosmeticDeskByUserid(orderby: "recent")
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
        cell?.productDescription.text = item.categories_name
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
        cell?.productPrice.text = formattedPrice! + "B"
        
        if item.product_img != ""{
            cell?.productImg.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
        }else{
            cell?.productImg.image = UIImage.init(named: "AppIcon")
        }
        // Configure the cell...
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = productList[indexPath.row]
        selectedProduct.append(item)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedProduct.lastIndex(of: productList[indexPath.row]){
            selectedProduct.remove(at: index)
        }
    }
    
    @IBAction func tapDone(_ sender: Any) {
        delegate?.finshedSelectItem(item: selectedProduct)
        navigationController?.popViewController(animated: true)
    }
}
