//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, CosmeticDetailDelegate, SearchFilterTableViewControllerDelegate {
    
    func filterResultCategory(item: CategoriesModel) {
        searchBrand = false
        searchCategory = true
        
        searchResultLabel.text = "Search Result from \(item.categories_name ?? "")"
        searchBar.placeholder = "Search \(item.categories_name ?? "")"
        
        loadingActivity.startAnimating()
        clearButton.isHidden = false
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByCategories(categoriesId: item.categories_id!)
    }
    
    func filterResultBrand(item: BrandModel) {
        searchBrand = true
        searchCategory = false
        
        searchResultLabel.text = "Search Result from \(item.brand_name ?? "")"
        searchBar.placeholder = "Search \(item.brand_name ?? "")"
        
        loadingActivity.startAnimating()
        clearButton.isHidden = false
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByBrands(brandId: item.brand_id!)
        
    }
    
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    private var allProduct: [ProductModel] = []
    private var searchedProduct: [ProductModel] = []
    
    private var categoriesList: [CategoriesModel] = []
    private var brandsList: [BrandModel] = []
    
    private var searchCategory: Bool = false
    private var searchBrand: Bool = false
    private var searching: Bool = false
    private var first: Bool = true
    
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var filterCollectionview: UICollectionView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        filterCollectionview.delegate = self
        filterCollectionview.dataSource = self
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    
    private func setCountLabel(count: Int){
        resultLabel.text = "About \(count) Cosmetics we're found."
    }
    
    //MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    //MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            
            var item:ProductModel
            let itemIndex = self.tableView.indexPathForSelectedRow?.row
            item = allProduct[itemIndex!]
            
            let destination = segue.destination as? CosmeticDetailViewController
            destination?.delegate = self
            destination?.productId = item.product_id
            
        }else if segue.identifier == "filter"{
            let destination = segue.destination as! SearchFilterTableViewController
            destination.delegate = self
            if filterCollectionview.indexPathsForSelectedItems?.first?.row == 0{
                destination.brandFilter = true
            }else if filterCollectionview.indexPathsForSelectedItems?.first?.row == 1{
                destination.categoryFilter = true
            }else{
                destination.categoryFilter = true
            }
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
            self.tableView.separatorStyle = .singleLine
            return allProduct.count
        
        }
        else if searchedProduct.count > 0 && searching{
            self.tableView.separatorStyle = .singleLine
            return searchedProduct.count
        }
        
        else if !first{
            self.tableView.separatorStyle = .none
            return 1
        }
            
        else{
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
    }
    
    var selectedCollectionCell: IndexPath!
    var previousSelect: IndexPath!

}

//MARK: - Category collection
extension SearchDetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol{
    
    //MARK: - Search Finished
    func itemDownloaded(item: NSMutableArray) {
        first = false
        allProduct = item as! [ProductModel]
        setCountLabel(count: allProduct.count)
        filterCollectionview.reloadData()
        self.tableView.reloadData()
        loadingActivity.stopAnimating()
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! CategoriesDetailCollectionViewCell
            cell.filterLabel.text = "Brand"
            cell.icon.image = UIImage.init(named: "search-brand")
            cell.layer.cornerRadius = 8
            if searchBrand{
                cell.filterLabel.textColor = UIColor.white
                cell.backgroundColor = UIColor.init(named: "cosmetic-color")
            }else{
                cell.filterLabel.textColor = UIColor.label
                cell.backgroundColor = nil
            }
            return cell
            
        }else if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! CategoriesDetailCollectionViewCell
            cell.filterLabel.text = "Categories"
            cell.icon.image = UIImage.init(named: "search-categories")
            cell.layer.cornerRadius = 8
            if searchCategory{
                cell.filterLabel.textColor = UIColor.white
                cell.backgroundColor = UIColor.init(named: "cosmetic-color")
            }else{
                cell.filterLabel.textColor = UIColor.label
                cell.backgroundColor = nil
            }
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtercell", for: indexPath) as! CategoriesDetailCollectionViewCell
            cell.filterLabel.text = "Filter"
            cell.icon.image = UIImage.init(named: "search-filter")
            cell.filterLabel.textColor = UIColor.label
            cell.backgroundColor = nil
            cell.layer.cornerRadius = 8
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func clearSearchCategory(){
        clearButton.isHidden = true
        allProduct.removeAll()
        searchedProduct.removeAll()
        first = true
        searching = false
        searchBrand = false
        searchCategory = false
        setCountLabel(count: 0)
        selectedCollectionCell = nil
        searchBar.placeholder = "Search Cosmetic"
        searchBar.text = ""
        searchResultLabel.text = "Search Result"
        
        filterCollectionview.reloadData()
        self.tableView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
    
}

//MARK: - Searchbar
extension SearchDetailTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBrand || searchCategory{
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
                clearButton.isHidden = false
                first = false
            }else{
                allProduct.removeAll()
                setCountLabel(count: 0)
                first = true
                self.tableView.reloadData()
                clearButton.isHidden = true
            }
        }

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
}
