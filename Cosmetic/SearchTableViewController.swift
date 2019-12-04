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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = stockResultsFeed.indexPathForSelectedRow?.row
            let item = resultItem[itemIndex!]
            destination?.productId = item.product_id
        }
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
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SearchTableViewCell

        let item: ProductModel = resultItem[indexPath.row]
        
        myCell.productTitle.text = item.product_name
        myCell.productDescription.text = item.product_description
        let imageUrl = URL(string: item.product_img!)!
        myCell.productImage.downloadImage(from: imageUrl)
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        navigationController?.pushViewController(searchDetailVc, animated: true)
    }
}
