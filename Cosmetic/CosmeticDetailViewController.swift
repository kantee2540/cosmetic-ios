//
//  CosmeticDetailViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CosmeticDetailViewController: UIViewController, DownloadProductProtocol, UITableViewDelegate, UITableViewDataSource {
    
    
    var productId: String!
    private var productData: [ProductModel] = []
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var contentTable: UITableView!
    
    func itemDownloaded(item: NSMutableArray) {
        productData = item as! [ProductModel]
        
        contentTable.delegate = self
        contentTable.dataSource = self
        
        contentTable.reloadData()
        self.removeSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadSelectItem(productId: productId)
    }
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell!
        
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "title")!
            cell.textLabel?.text = productData[0].product_name
        }
            
        else if indexPath.row == 1{
            cell = tableView.dequeueReusableCell(withIdentifier: "description")!
            cell.textLabel?.text = productData[0].product_description
        }
        else if indexPath.row == 2{
            let imageCell = tableView.dequeueReusableCell(withIdentifier: "image") as! ImageTableViewCell
            imageCell.selectionStyle = .none
            
            let imgUrl = productData[0].product_img
            imageCell.productImage.downloadImage(from: URL(string: imgUrl!)!)
            
            return imageCell
        }
        
        else if indexPath.row == 3{
            cell = tableView.dequeueReusableCell(withIdentifier: "information")
            cell.textLabel?.text = "Price :"
            
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
            
            cell.detailTextLabel?.text = formattedPrice! + " Baht"
        }
        
        else if indexPath.row == 4{
            cell = tableView.dequeueReusableCell(withIdentifier: "information")
            cell.textLabel?.text = "Categories :"
            cell.detailTextLabel?.text = productData[0].categories_name
        }
        
        else if indexPath.row == 5{
            cell = tableView.dequeueReusableCell(withIdentifier: "information")
            cell.textLabel?.text = "Categories Type :"
            cell.detailTextLabel?.text = productData[0].categories_type
        }
        
        else if indexPath.row == 6{
            cell = tableView.dequeueReusableCell(withIdentifier: "ingredient")
            cell.textLabel?.text = "Ingredient :"
            cell.detailTextLabel?.text = productData[0].ingredient
            
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    

    
    //MARK: - Show Detail after loaded
//    func showDetail(){
//        productName.text = productData[0].product_name
//        productDescription.text = productData[0].product_description
//        coverImage.downloadImage(from: URL(string: productData[0].product_img!)!)
//        brandName.text = productData[0].brand_name?.uppercased()
//        let numberFormat = NumberFormatter()
//        numberFormat.numberStyle = .decimal
//        let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
//        price.text = formattedPrice
//    }
    
    

}
