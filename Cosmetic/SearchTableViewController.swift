//
//  SearchTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 30/4/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, DownloadProductProtocol, CosmeticDetailDelegate {
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    var resultItem :[ProductModel] = []
    var searchBar :UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.showSpinner(onView: self.view)
        self.tableView.addSubview(searchRefreshControl)
        downloadProduct()
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
            let itemIndex = self.tableView.indexPathForSelectedRow?.row
            let item = resultItem[itemIndex!]
            destination?.delegate = self
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
    
    lazy var searchRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlerRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc private func handlerRefresh(_ refreshControl: UIRefreshControl){
        downloadProduct()
    }
    
    private func downloadProduct(){
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadLimitItem(limitNum: 15)
    }
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [ProductModel]
        self.tableView.reloadData()
        self.removeSpinner()
        searchBar.isUserInteractionEnabled = true
        searchRefreshControl.endRefreshing()
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
        searchRefreshControl.endRefreshing()
    }
    
}

extension SearchTableViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchDetailVc = storyboard?.instantiateViewController(withIdentifier: "SearchDetailView") as! SearchDetailTableViewController
        navigationController?.pushViewController(searchDetailVc, animated: true)
    }
}
