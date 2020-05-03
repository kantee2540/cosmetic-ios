//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, CosmeticDetailDelegate, FilterTableViewControllerDelegate {
    func applyFilter(brand: BrandModel, category: CategoriesModel) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByCategoriesAndBrand(categoriesId: category.categories_id!, brandId: brand.brand_id!)
        filterView.isHidden = false
        filterLabel.text = "2 Filtered"
        searchCategory = true
        searchBrand = true
        clearButton.isHidden = false
        first = false
    }
    
    func applyCategory(category: CategoriesModel) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByCategories(categoriesId: category.categories_id!)
        filterView.isHidden = false
        filterLabel.text = "Category: \(category.categories_name ?? "")"
        searchCategory = true
        clearButton.isHidden = false
        first = false
        
    }
    
    func applyBrand(brand: BrandModel) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByBrands(brandId: brand.brand_id!)
        filterView.isHidden = false
        filterLabel.text = "Brand: \(brand.brand_name ?? "")"
        searchBrand = true
        clearButton.isHidden = false
        first = false
    }
    
    
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    private var filtedItem: [String] = []
    private var allProduct: [ProductModel] = []
    private var searchedProduct: [ProductModel] = []
    
    private var categoriesList: [CategoriesModel] = []
    private var brandsList: [BrandModel] = []
    
    private var searchCategory: Bool = false
    private var searchBrand: Bool = false
    private var searching: Bool = false
    private var first: Bool = true
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var searchResultLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        filterView.layer.cornerRadius = 6
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
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
            let destination = segue.destination as? FilterTableViewController
            destination?.delegate = self
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
                searchingCell.notifyDescription.text = "Type your keyword or Filter by category or brand from filter search menu"
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
extension SearchDetailTableViewController: DownloadProductProtocol{
    
    //MARK: - Search Finished
    func itemDownloaded(item: NSMutableArray) {
        first = false
        allProduct = item as! [ProductModel]
        setCountLabel(count: allProduct.count)
        self.tableView.reloadData()
        loadingActivity.stopAnimating()
        
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
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
        filterView.isHidden = true
        searchBar.placeholder = "Search Cosmetic"
        searchBar.text = ""
        searchResultLabel.text = "Search Result"
        self.tableView.reloadData()
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
