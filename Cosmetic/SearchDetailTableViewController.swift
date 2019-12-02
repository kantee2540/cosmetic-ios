//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, DownloadCategoriesProtocol {

    var allProduct: [ProductModel]!
    private var searchedProduct: [ProductModel] = []
    var categoriesList: [CategoriesModel] = []
    private var searching :Bool = false
    
    private var categories: [String] = ["S", "B", "V"]
    @IBOutlet var searchTable: UITableView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()

        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func itemDownloaded(item: NSMutableArray) {
        self.categoriesList = item as! [CategoriesModel]
        categoriesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            
            var item:ProductModel
            let itemIndex = searchTable.indexPathForSelectedRow?.row
            if searching{
                item = searchedProduct[itemIndex!]
            }else{
                item = allProduct[itemIndex!]
            }
            let destination = segue.destination as? CosmeticDetailViewController
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
        if(searching){
            return searchedProduct.count
        }
        else{
            return allProduct.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searching){
            let searchingCell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
            let item = searchedProduct[indexPath.row]
            
            searchingCell?.productName.text = item.product_name
            searchingCell?.productDescription.text = item.product_description
            searchingCell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
            
            return searchingCell!
        }
            
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
            let item = allProduct[indexPath.row]
            
            cell?.productName.text = item.product_name
            cell?.productDescription.text = item.product_description
            cell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
            
            return cell!
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SearchDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item :CategoriesModel = categoriesList[indexPath.row]
        let collectionCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesReuse", for: indexPath) as! CategoriesDetailCollectionViewCell
        
        collectionCategoriesCell.categoriesName.text = item.categories_name
        
        return collectionCategoriesCell
    }
    
    
}

extension SearchDetailTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchedProduct = allProduct.filter(){
            return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
        }
        if(searchText.count != 0){
            searching = true
        }else{
            searching = false
        }
        searchTable.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
