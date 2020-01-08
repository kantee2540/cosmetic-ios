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
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var ingredient: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    func itemDownloaded(item: NSMutableArray) {
        productData = item as! [ProductModel]
        brandName.text = productData[0].brand_name?.uppercased()
        productNameLabel.text = productData[0].product_name
        productDescriptionLabel.text = productData[0].product_description
        productImage.downloadImage(from: URL(string: productData[0].product_img!)!)
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
        priceLabel.text = formattedPrice! + " Baht"
        
        categoryLabel.text = productData[0].categories_name
        categoryTypeLabel.text = productData[0].categories_type
        if productData[0].ingredient != "n/a"{
            ingredient.text = productData[0].ingredient
        }else{
            ingredient.text = "Ingredient not available"
        }
        
        self.removeSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadSelectItem(productId: productId)
        
        priceView.makeRoundedView()
        categoryView.makeRoundedView()
        saveButton.roundedCorner()
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        let titleActivity: String = productData[0].product_name!
        let description: String = productData[0].product_description!
        let image: UIImage = productImage.image!
        let activityViewController = UIActivityViewController(activityItems: [titleActivity, description, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityViewController, animated: true, completion: nil)
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
