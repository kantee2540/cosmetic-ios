//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, DownloadCategoriesProtocol {

    private var allProduct: [ProductModel] = []
    private var productByCategories: [ProductModel] = []
    private var searchedProduct: [ProductModel] = []
    var categoriesList: [CategoriesModel] = []
    private var searching :Bool = false
    private var searchingCategories :Bool = false
    
    @IBOutlet var searchTable: UITableView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCategories()
        downloadProduct()

        searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    private func downloadCategories(){
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()
    }
    
    private func downloadProduct(){
        showSpinner(onView: self.view)
        searchTable.delegate = self
        searchTable.dataSource = self
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        self.categoriesList = item as! [CategoriesModel]
        categoriesCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            
            var item:ProductModel
            let itemIndex = searchTable.indexPathForSelectedRow?.row
            if searching{
                item = searchedProduct[itemIndex!]
            }
            else if searchingCategories{
                item = productByCategories[itemIndex!]
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
            if searchedProduct.count > 0{
                return searchedProduct.count
            }else{
                return 1
            }
            
        }
        else if (searchingCategories){
            if productByCategories.count > 0{
                return productByCategories.count
            }else{
                return 1
            }
        }
        else{
            return allProduct.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searching){
            if searchedProduct.count > 0{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                let item = searchedProduct[indexPath.row]
                
                searchingCell?.productName.text = item.product_name
                searchingCell?.productDescription.text = item.product_description
                searchingCell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
                
                return searchingCell!
                
            }else{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath)
                return searchingCell
            }
            
        }
            
        else if (searchingCategories){
            if productByCategories.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                let item = productByCategories[indexPath.row]
                
                cell?.productName.text = item.product_name
                cell?.productDescription.text = item.product_description
                cell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
                
                return cell!
                
            }
            else{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath)
                return searchingCell
            }
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
    
    var selectedCollectionCell: IndexPath!
    var previousSelect: IndexPath!

}

extension SearchDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol{
    func itemDownloaded(item: NSMutableArray) {
        if searchingCategories{
            productByCategories = item as! [ProductModel]
        }else{
            allProduct = item as! [ProductModel]
        }
        searchTable.reloadData()
        removeSpinner()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item :CategoriesModel = categoriesList[indexPath.row]
        let collectionCategoriesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesReuse", for: indexPath) as! CategoriesDetailCollectionViewCell
        
        collectionCategoriesCell.layer.cornerRadius = 8
        collectionCategoriesCell.layer.masksToBounds = true
        
        //Check selected? cell
        if selectedCollectionCell != nil && indexPath == selectedCollectionCell{
            collectionCategoriesCell.backgroundColor = UIColor.init(named: "main-font-color")
            collectionCategoriesCell.categoriesIcon.tintColor = UIColor.white
            collectionCategoriesCell.categoriesName.textColor = UIColor.white
            
        }
        else{
            collectionCategoriesCell.backgroundColor = nil
            collectionCategoriesCell.categoriesIcon.tintColor = UIColor.init(named: "main-font-color")
            if #available(iOS 13.0, *) {
                collectionCategoriesCell.categoriesName.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
                collectionCategoriesCell.categoriesName.textColor = UIColor.black
            }
        }
        
        collectionCategoriesCell.categoriesName.text = item.categories_name
        
        return collectionCategoriesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Selected Cell
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesDetailCollectionViewCell
        cell.backgroundColor = UIColor.init(named: "main-font-color")
        cell.categoriesIcon.tintColor = UIColor.white
        cell.categoriesName.textColor = UIColor.white
        
        //Search Product by categories Id
        
        if selectedCollectionCell == indexPath{
            selectedCollectionCell = nil
            searchingCategories = false
            searchBar.placeholder = "Search Cosmetic"
            searchTable.reloadData()
            
            let cell = collectionView.cellForItem(at: indexPath) as? CategoriesDetailCollectionViewCell
            cell?.backgroundColor = nil
            cell?.categoriesIcon.tintColor = UIColor.init(named: "main-font-color")
            if #available(iOS 13.0, *) {
                cell?.categoriesName.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
                cell?.categoriesName.textColor = UIColor.black
            }
        }else{
            selectedCollectionCell = indexPath
            showSpinner(onView: self.view)
            searchingCategories = true
            searching = false
            
            let item = categoriesList[indexPath.row]
            let downloadProduct = DownloadProduct()
            downloadProduct.delegate = self
            downloadProduct.downloadByCategories(categoriesId: item.categories_id!)
            
            searchBar.placeholder = "Search \(String(item.categories_name!))"
            searchBar.text = ""
            searchBar.resignFirstResponder()
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoriesDetailCollectionViewCell
        cell?.backgroundColor = nil
        cell?.categoriesIcon.tintColor = UIColor.init(named: "main-font-color")
        if #available(iOS 13.0, *) {
            cell?.categoriesName.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            cell?.categoriesName.textColor = UIColor.black
        }
    }
    
}

extension SearchDetailTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchingCategories{
            searchedProduct = productByCategories.filter(){
                return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
            }
        }else{
            searchedProduct = allProduct.filter(){
                return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
            }
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
