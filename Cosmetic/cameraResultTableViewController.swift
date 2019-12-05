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
                let exProductName = extractString(toExtract: productName)
                
                for x in exProductName{
                    if capturedWord.contains(where: {$0 == x.lowercased()}){
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
    
    private func extractString(toExtract string: String) -> Array<String>{
        var exString: Array<String> = Array()
        
        var startCount :Int = 0
        var charCount :Int = 0
                
        while charCount < string.count {
            if string[string.index(string.startIndex, offsetBy: charCount)] == " "{
                let startIndex = string.index(string.startIndex, offsetBy: startCount)
                let endIndex = string.index(string.startIndex, offsetBy: charCount)
                        
                let exText = string[startIndex..<endIndex]
                if exText.count > 3{
                    exString.append(String(exText.lowercased()))
                }
                startCount = charCount + 1
            }
                charCount += 1
        }
        
        return exString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()
        showSpinner(onView: self.view)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = resultTableView.indexPathForSelectedRow?.row
            let item = searchedProduct[itemIndex!]
            destination?.productId = item.product_id
        }
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
