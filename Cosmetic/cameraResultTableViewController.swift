//
//  cameraResultTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 7/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class cameraResultTableViewController: UITableViewController, DownloadProductProtocol {
    
    var keyword: String = ""
    var capturedWord: Array<String>!
    var resultItem: [ProductModel] = []
    var searchedProduct: [ProductModel] = []
    var session :URLSession!
    
    @IBOutlet var resultTableView: UITableView!
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [ProductModel]
        if capturedWord != nil{
            for item in resultItem{
                
                let productName = item.product_name!
                var exProductName: Array<String>! = Array()
                
                var startCount :Int = 0
                var charCount :Int = 0
                        
                while charCount < productName.count {
                    if productName[productName.index(productName.startIndex, offsetBy: charCount)] == " "{
                        let startIndex = productName.index(productName.startIndex, offsetBy: startCount)
                        let endIndex = productName.index(productName.startIndex, offsetBy: charCount)
                                
                        let exText = productName[startIndex..<endIndex]
                        exProductName.append(String(exText.lowercased()))
                        startCount = charCount + 1
                    }
                        charCount += 1
                }
                
                for x in exProductName{
                    if capturedWord.contains(x){
                        searchedProduct.append(item)
                    }
                }
            }
            
        }
        if searchedProduct.count != 0{
            resultTableView.separatorStyle = .singleLine
        }
        else{
            resultTableView.separatorStyle = .none
        }
        
        resultTableView.reloadData()
        removeSpinner()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()
        showSpinner(onView: self.view)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchedProduct.count != 0{
            return searchedProduct.count
        }
        else{
            return 1
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// If have item for display
        if searchedProduct.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultViewCell", for: indexPath) as! CameraResultTableViewCell
            let item :ProductModel = searchedProduct[indexPath.row]
            
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
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "noItem", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }

        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchedProduct.count != 0{
            let infoVC = storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
            let item :ProductModel = searchedProduct[indexPath.row]
            infoVC.product_name = item.product_name
            infoVC.product_description = item.product_description
            infoVC.product_price = item.product_price
            infoVC.categories_name = item.categories_name
            infoVC.brand_name = item.brand_name
            infoVC.product_img = item.product_img
            navigationController?.pushViewController(infoVC, animated: true)
        }
        else{
            
        }
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
