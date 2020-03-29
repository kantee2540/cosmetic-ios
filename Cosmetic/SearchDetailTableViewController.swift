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
    private var searchedProduct: [ProductModel] = []
    
    private var categoriesList: [CategoriesModel] = []
    private var brandsList: [BrandModel] = []
    
    private var searchingCategories :Bool = false
    private var searchingBrand: Bool = false
    private var searching: Bool = false
    private var first: Bool = true
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var selectionSegment: UISegmentedControl!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        downloadCategories()
        
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
    
    private func downloadProductByCategory(categoryId: String){
        let downloadProducts = DownloadProduct()
        downloadProducts.delegate = self
        downloadProducts.downloadByCategories(categoriesId: categoryId)
    }
    
    private func downloadProductByBrand(brandId: String){
        let downloadProducts = DownloadProduct()
        downloadProducts.delegate = self
        downloadProducts.downloadByBrands(brandId: brandId)
    }
    
    private func downloadBrand(){
        let downloadBrand = DownloadBrands()
        downloadBrand.delegate = self
        downloadBrand.downloadItem()
    }
    
    private func setCountLabel(count: Int){
        resultLabel.text = "About \(count) Cosmetics we're found."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        self.categoriesList = item as! [CategoriesModel]
        categoriesCollectionView.reloadData()
        loadingActivity.stopAnimating()
    }
    
    func itemDownloadedBrands(item: NSMutableArray) {
        self.brandsList = item as! [BrandModel]
        categoriesCollectionView.reloadData()
        loadingActivity.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            
            var item:ProductModel
            let itemIndex = self.tableView.indexPathForSelectedRow?.row
            item = allProduct[itemIndex!]
            
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
        
        if allProduct.count > 0 && !searching{
            clearButton.isEnabled = true
            self.tableView.separatorStyle = .singleLine
            return allProduct.count
        
        }
        else if searchedProduct.count > 0 && searching{
            self.tableView.separatorStyle = .singleLine
            return searchedProduct.count
        }
        
        else if !first{
            clearButton.isEnabled = true
            self.tableView.separatorStyle = .none
            return 1
        }
            
        else{
            clearButton.isEnabled = false
            self.tableView.separatorStyle = .none
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if allProduct.count > 0 && !searching{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
            
            let item = allProduct[indexPath.row]
            
            cell?.selectionStyle = .default
            cell?.productName.text = item.product_name
                //cell?.productDescription.text = item.product_description
            if item.product_img != ""{
                cell?.productImg.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            }else{
                cell?.productImg.image = UIImage.init(named: "AppIcon")
            }
            return cell!
                
        }
            
        //Searching by brand
        else if searchedProduct.count > 0 && searching{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
            
            let item = searchedProduct[indexPath.row]
            cell?.selectionStyle = .default
            cell?.productName.text = item.product_name
                //cell?.productDescription.text = item.product_description
            cell?.productImg.downloadImage(from: URL(string: item.product_img!)!)
            return cell!
        }
        
        else{
                
            if first{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                
                searchingCell.selectionStyle = .none
                searchingCell.title.text = "Search Cosmetic"
                searchingCell.notifyDescription.text = "Type your keyword or choose the brand or category of cosmetics"
                return searchingCell
                    
            }else{
                let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                
                searchingCell.selectionStyle = .none
                searchingCell.title.text = "Product Not Found"
                searchingCell.notifyDescription.text = "Please try search another word to search"
                return searchingCell
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
        self.tableView.reloadData()
    }
    
    
    @IBAction func segmentAction(_ sender: Any) {
        loadingActivity.startAnimating()
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
        allProduct = item as! [ProductModel]
        setCountLabel(count: allProduct.count)
        
        self.tableView.reloadData()
        loadingActivity.stopAnimating()
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
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
            self.tableView.reloadData()
            
        }else{
            loadingActivity.startAnimating()
            allProduct.removeAll()
            selectedCollectionCell = indexPath
            if selectionSegment.selectedSegmentIndex == 0{
                searchingCategories = true
                
                let item = categoriesList[indexPath.row]
                downloadProductByCategory(categoryId: item.categories_id!)
                searchBar.placeholder = "Search \(String(item.categories_name!))"
            }
            
            else if selectionSegment.selectedSegmentIndex == 1{
                searchingBrand = true
                
                let item = brandsList[indexPath.row]
                downloadProductByBrand(brandId: item.brand_id!)
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
        
        allProduct.removeAll()
        searchedProduct.removeAll()
        first = true
        setCountLabel(count: 0)
        clearButton.isEnabled = false
        selectedCollectionCell = nil
        searchingCategories = false
        searchingBrand = false
        searchBar.placeholder = "Search Cosmetic"
        searchBar.text = ""
        
        self.tableView.reloadData()
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
        if searchingCategories || searchingBrand{
            searchedProduct = allProduct.filter(){
                return ($0.product_name?.lowercased() ?? "").contains(searchText.lowercased())
            }
            if searchText.count > 0{
                searching = true
                setCountLabel(count: searchedProduct.count)
            }else{
                searching = false
                setCountLabel(count: allProduct.count)
            }
            self.tableView.reloadData()
        }
        
        else{
            if searchBar.text!.count > 0{
                loadingActivity.startAnimating()
                let downloadProducts = DownloadProduct()
                downloadProducts.delegate = self
                downloadProducts.searchByKeyword(searchBar.text?.lowercased() ?? "")
                first = false
            }else{
                allProduct.removeAll()
                setCountLabel(count: 0)
                first = true
                self.tableView.reloadData()
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
}
