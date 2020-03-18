//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, DownloadCategoriesProtocol, DownloadBrandProtocol, CosmeticDetailDelegate {
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    private var allProduct: [ProductModel] = []
    private var productByCategories: [ProductModel] = []
    private var productByBrands: [ProductModel] = []
    private var searchedProduct: [ProductModel] = []
    private var categoriesList: [CategoriesModel] = []
    private var brandsList: [BrandModel] = []
    private var searching :Bool = false
    private var searchingCategories :Bool = false
    private var searchingBrand: Bool = false
    private var first: Bool = true
    
    private var downloadProducts = DownloadProduct()
    
    @IBOutlet var searchTable: UITableView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var selectionSegment: UISegmentedControl!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        downloadCategories()
        downloadProduct()

        searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    //MARK: - Download Categories list
    private func downloadCategories(){
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()
    }
    
    //MARK: - Download Products list
    private func downloadProduct(){
        searchTable.delegate = self
        searchTable.dataSource = self
//        downloadProducts = DownloadProduct()
        downloadProducts.delegate = self
//        downloadProducts.downloadItem()
    }
    
    private func downloadBrand(){
        let downloadBrand = DownloadBrands()
        downloadBrand.delegate = self
        downloadBrand.downloadItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        self.categoriesList = item as! [CategoriesModel]
        categoriesCollectionView.reloadData()
    }
    
    func itemDownloadedBrands(item: NSMutableArray) {
        self.brandsList = item as! [BrandModel]
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
            }
            else if searchingBrand{
                item = productByBrands[itemIndex!]
            }
            else{
                item = allProduct[itemIndex!]
            }
            let destination = segue.destination as? CosmeticDetailViewController
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
        // #warning Incomplete implementation, return the number of rows
        if searching{
            clearButton.isEnabled = true
            if searchedProduct.count > 0{
                return searchedProduct.count
            }else{
                return 1
            }
            
        }
        else if searchingCategories{
            if productByCategories.count > 0{
                return productByCategories.count
            }else{
                return 1
            }
        }
            
        else if searchingBrand{
            if productByBrands.count > 0{
                return productByBrands.count
            }else{
                return 1
            }
        }
            
        else{
            
            if allProduct.count > 0{
                clearButton.isEnabled = true
                return allProduct.count
            
            }else if !first{
                clearButton.isEnabled = true
                return 1
            }
            
            else{
                clearButton.isEnabled = false
                return 1
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: - Searching Cell
        if(searching){
            if searchedProduct.count > 0{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                let item = searchedProduct[indexPath.row]
                
                searchingCell?.productName.text = item.product_name
                searchingCell?.productDescription.text = item.product_description
                searchingCell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
                
                return searchingCell!
                
            }else{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                searchingCell.title.text = "Product Not Found"
                searchingCell.notifyDescription.text = "Please try search another word to search"
                return searchingCell
            }
            
        }
        
        //MARK: - Searching Category
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
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                searchingCell.title.text = "Product Not Found"
                searchingCell.notifyDescription.text = "Please try search another word to search"
                return searchingCell
            }
        }
            
        else if searchingBrand {
            if productByBrands.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                let item = productByBrands[indexPath.row]
                           
                cell?.productName.text = item.product_name
                cell?.productDescription.text = item.product_description
                cell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
                           
                return cell!
                           
            }
            else{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                searchingCell.title.text = "Product Not Found"
                searchingCell.notifyDescription.text = "Please try search another word to search"
                return searchingCell
            }
        }
        
        //MARK: - Nothing search
        else {
            if allProduct.count > 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                let item = allProduct[indexPath.row]
                
                cell?.productName.text = item.product_name
                cell?.productDescription.text = item.product_description
                cell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
                return cell!
            }else{
                
                if first{
                    let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                    searchingCell.title.text = "Search Cosmetic"
                    searchingCell.notifyDescription.text = "Type your keyword or choose the brand or category of cosmetics"
                    return searchingCell
                    
                }else{
                    let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                    searchingCell.title.text = "Product Not Found"
                    searchingCell.notifyDescription.text = "Please try search another word to search"
                    return searchingCell
                }
                
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Tap clear
    @IBAction func tapClear(_ sender: Any) {
        clearSearchCategory()
        first = true
        allProduct.removeAll()
        searchTable.reloadData()
    }
    
    
    @IBAction func segmentAction(_ sender: Any) {
        if searchingCategories || searchingBrand{
            clearSearchCategory()
        }
        
        if selectionSegment.selectedSegmentIndex == 0{
            downloadCategories()
        }
        else if selectionSegment.selectedSegmentIndex == 1{
            downloadBrand()
        }
    }
    
    var selectedCollectionCell: IndexPath!
    var previousSelect: IndexPath!

}

//MARK: - Category collection
extension SearchDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol{
    
    //MARK: - Search Finished
    func itemDownloaded(item: NSMutableArray) {
        if searchingCategories{
            productByCategories = item as! [ProductModel]
        }
        else if searchingBrand{
            productByBrands = item as! [ProductModel]
        }
        
        else{
            allProduct = item as! [ProductModel]
        }
        searchTable.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectionSegment.selectedSegmentIndex == 0{
            return categoriesList.count
        }
        
        else if selectionSegment.selectedSegmentIndex == 1{
            return brandsList.count
        }
        
        else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
        if selectionSegment.selectedSegmentIndex == 0{
            let item :CategoriesModel = categoriesList[indexPath.row]
            collectionCategoriesCell.categoriesName.text = item.categories_name
            collectionCategoriesCell.categoriesIcon.backgroundColor = nil
            collectionCategoriesCell.categoriesIcon.image = UIImage.init(systemName: "bag.fill")
        }
        
        else if selectionSegment.selectedSegmentIndex == 1{
            let item :BrandModel = brandsList[indexPath.row]
            collectionCategoriesCell.categoriesName.text = item.brand_name
            collectionCategoriesCell.categoriesIcon.backgroundColor = UIColor.white
            collectionCategoriesCell.categoriesIcon.downloadImage(from: URL(string: item.brand_logo!)!)
        }
        
        return collectionCategoriesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Selected Cell
        first = false
        clearButton.isEnabled = true
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesDetailCollectionViewCell
        cell.backgroundColor = UIColor.init(named: "main-font-color")
        cell.categoriesIcon.tintColor = UIColor.white
        cell.categoriesName.textColor = UIColor.white
        
        //Search Product by categories Id
        
        if selectedCollectionCell == indexPath{
            clearSearchCategory()
            first = true
            allProduct.removeAll()
            searchTable.reloadData()
            
        }else{
            selectedCollectionCell = indexPath
            
            searching = false
            
            if selectionSegment.selectedSegmentIndex == 0{
                searchingCategories = true
                let item = categoriesList[indexPath.row]
                downloadProducts.downloadByCategories(categoriesId: item.categories_id!)
                searchBar.placeholder = "Search \(String(item.categories_name!))"
            }
            
            else if selectionSegment.selectedSegmentIndex == 1{
                searchingBrand = true
                let item = brandsList[indexPath.row]
                downloadProducts.downloadByBrands(brandId: item.brand_id!)
                searchBar.placeholder = "Search \(String(item.brand_name!))"
            }
            
            searchBar.text = ""
            searchBar.resignFirstResponder()
            
        }
    }
    
    private func clearSearchCategory(){
        if searchingCategories || searchingBrand{
            let cell = categoriesCollectionView.cellForItem(at: selectedCollectionCell) as? CategoriesDetailCollectionViewCell
            cell?.backgroundColor = nil
            cell?.categoriesIcon.tintColor = UIColor.init(named: "main-font-color")
            if #available(iOS 13.0, *) {
                cell?.categoriesName.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
                cell?.categoriesName.textColor = UIColor.black
            }
        }
        clearButton.isEnabled = false
        selectedCollectionCell = nil
        searchingCategories = false
        searchingBrand = false
        searching = false
        searchBar.placeholder = "Search Cosmetic"
        searchBar.text = ""
        
        searchTable.reloadData()
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

//MARK: - Searchbar
extension SearchDetailTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchingCategories{
            searchedProduct = productByCategories.filter(){
                return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
            }
        }
        else if searchingBrand{
            searchedProduct = productByBrands.filter(){
                return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
            }
        }
        
        else{
            
        }
        if(searchText.count != 0 && (searchingCategories || searchingBrand)){
            searching = true
        }else{
            searching = false
        }
        searchTable.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchingBrand || !searchingCategories{
            downloadProducts.searchByKeyword(searchBar.text?.lowercased() ?? "")
            first = false
            searchBar.resignFirstResponder()
            
        }else{
            searchBar.resignFirstResponder()
        }
    }
}
