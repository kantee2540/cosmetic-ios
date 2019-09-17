//
//  SearchTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 30/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, DownloadProductProtocol {
    
    
    var item_name :[String] = []
    var result :[String] = []
    
    var resultItem :[ProductModel] = []
    var filtered: [ProductModel] = []
    var searching: Bool = false
    
    @IBOutlet var stockResultsFeed: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stockResultsFeed.delegate = self
        self.stockResultsFeed.dataSource = self
        
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //page title
        tabBarController?.navigationItem.title = "Search"
        
        //Search button on top-right
        let cammerabtn_image = UIImage(named: "searchIcon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(searchPage(_:)))
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.rightBarButtonItem = cammerabtn
        
        
        
        searchBar.delegate = self
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.navigationItem.rightBarButtonItem = nil
        item_name.removeAll()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searching{
            return filtered.count
        }
        else{
            return resultItem.count
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        if searching{
            let item: ProductModel = filtered[indexPath.row]
            
            //Cell Edit
            myCell.textLabel!.text = item.product_name
            myCell.detailTextLabel?.text = item.product_description
            myCell.imageView!.image = UIImage(named: "brashIcon")
        }
        
        else{
            let item: ProductModel = resultItem[indexPath.row]
            
                //Cell Edit
            myCell.textLabel!.text = item.product_name
            myCell.detailTextLabel?.text = item.product_description
            myCell.imageView!.image = UIImage(named: "brashIcon")
        }
        
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:ProductModel
        let infoVC = storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
        if searching{
            item = filtered[indexPath.row]
        }
        else{
            item = resultItem[indexPath.row]
        }
        
        infoVC.product_name = item.product_name
        infoVC.product_description = item.product_description
        infoVC.product_price = item.product_price
        infoVC.categories_name = item.categories_name
        infoVC.brand_name = item.brand_name
        infoVC.product_img = item.product_img
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [ProductModel]
        self.stockResultsFeed.reloadData()
        self.removeSpinner()
    }
    
    
    @objc func searchPage(_ :UIBarButtonItem){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailView")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension SearchTableViewController: UISearchBarDelegate{
    //SEARCH
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = resultItem.filter(){
            return ($0.product_name ?? "").contains(searchText)
        }
        //print(filtered)
        searchBar.showsCancelButton = true
        if searchText == ""{
            searching = false
        }
        else{
            searching = true
        }
        
        stockResultsFeed.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searching = false
        stockResultsFeed.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

var vSpinner :UIView?
extension SearchTableViewController{
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
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
