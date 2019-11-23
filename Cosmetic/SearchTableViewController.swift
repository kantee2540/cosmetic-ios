//
//  SearchTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 30/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, DownloadProductProtocol {

    var resultItem :[ProductModel] = []
    
    var searchBar :UISearchBar = UISearchBar()
    @IBOutlet var stockResultsFeed: UITableView!
    
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
        searchBar.placeholder = "Search Cosmetic"
        searchBar.delegate = self
        tabBarController?.navigationItem.titleView = searchBar
        tabBarController?.navigationItem.title = ""
        if(resultItem.count <= 0){
            searchBar.isUserInteractionEnabled = false
        }else{
            searchBar.isUserInteractionEnabled = true
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.navigationItem.titleView = nil
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultItem.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        let item: ProductModel = resultItem[indexPath.row]
            
        //Cell Edit
        myCell.textLabel!.text = item.product_name
        myCell.detailTextLabel?.text = item.product_description
        myCell.imageView!.image = UIImage(named: "brashIcon")
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:ProductModel
        let infoVC = storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
        item = resultItem[indexPath.row]
        
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
        searchBar.isUserInteractionEnabled = true
    }
    
}

extension SearchTableViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchDetailVc = storyboard?.instantiateViewController(withIdentifier: "SearchDetailView") as! SearchDetailTableViewController
        searchDetailVc.allProduct = resultItem
        navigationController?.pushViewController(searchDetailVc, animated: true)
    }
}
