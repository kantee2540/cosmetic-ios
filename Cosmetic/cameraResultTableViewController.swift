//
//  cameraResultTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 7/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class cameraResultTableViewController: UITableViewController, DownloadProductSearch {
    
    var keyword: String = ""
    var resultItem: [ProductModel] = []
    var session :URLSession!
    
    @IBOutlet var resultTableView: UITableView!
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [ProductModel]
        resultTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        
        let downloadProductSearch = DownloadProductSearchCamera()
        downloadProductSearch.delegate = self
        downloadProductSearch.downloadItem(searchKeyword: keyword)

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
        return resultItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultViewCell", for: indexPath) as! CameraResultTableViewCell
        let item :ProductModel = resultItem[indexPath.row]
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
