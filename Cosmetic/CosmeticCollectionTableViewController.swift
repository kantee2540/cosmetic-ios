//
//  CosmeticCollectionTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 15/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CosmeticCollectionTableViewController: UITableViewController, DownloadProductByCategoriesProtocol {
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [ProductModel]
        resultTable.reloadData()
        self.removeSpinner()
    }

    var categories_id :String!
    var categories_name :String!
    var resultItem :[ProductModel] = []
    var session :URLSession!
    
    @IBOutlet var resultTable: UITableView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = categories_name
        resultTable.delegate = self
        
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProductByCategories()
        downloadProduct.delegate = self
        downloadProduct.downloadItem(categories_id: categories_id)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! CollectionTableViewCell
        let item :ProductModel = resultItem[indexPath.row]
//        cell.textLabel?.text = item.product_name
//        cell.detailTextLabel?.text = item.product_description
        cell.titleTextView.text = item.product_name
        cell.detailTextView.text = item.product_description
        cell.priceTextView.text = "Price : " + item.product_price! + " Baht"
        
        //DownloadImage
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
        
        //
        
        // Configure the cell...

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
    

    

}

var vSpinnerCollection :UIView?
extension CosmeticCollectionTableViewController{
    func showSpinner(onView :UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinnerCollection = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinnerCollection?.removeFromSuperview()
            vSpinnerCollection = nil
        }
    }
}
