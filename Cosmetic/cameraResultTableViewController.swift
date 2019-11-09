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
        resultTableView.reloadData()
            
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()

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
        return searchedProduct.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultViewCell", for: indexPath) as! CameraResultTableViewCell
        let item :ProductModel = searchedProduct[indexPath.row]
        
        cell.titleTextView.text = item.product_name
        cell.descriptionTextView.text = item.product_description
        cell.priceTextView.text = "Price : \(item.product_price!) Baht"
        
        let imageURL = URL(string: item.product_img!)
        
        DispatchQueue.global().async {
            self.session = URLSession(configuration: .default)
            
            let getImageFromUrl = self.session.dataTask(with: imageURL!) { data, responds, error in
                if let e = error{
                    print("Error = \(e)")
                }
                else {
                    if (responds as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            
                            DispatchQueue.main.async {
                                cell.productImage.image = UIImage(data: imageData)
                            }
                        }
                        else{
                            print("Image file is currupted")
                        }
                    }
                    else{
                        print("No response from server")
                    }
                }
            }
            
            getImageFromUrl.resume()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
        let item :ProductModel = resultItem[indexPath.row]
        infoVC.product_name = item.product_name
        infoVC.product_description = item.product_description
        infoVC.product_price = item.product_price
        infoVC.categories_name = item.categories_name
        infoVC.brand_name = item.brand_name
        infoVC.product_img = item.product_img
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
