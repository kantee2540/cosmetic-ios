//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController, CosmeticDetailDelegate, FilterTableViewControllerDelegate {
    
    func applyFilter(brand: BrandModel, category: CategoriesModel, minPrice: Int?, maxPrice: Int?) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByCategoriesAndBrand(categoriesId: category.categories_id!, brandId: brand.brand_id!, minPrice: minPrice, maxPrice: maxPrice)
        filterView.isHidden = false
        if minPrice == nil && maxPrice == nil{
            filterLabel.text = "2 Filtered"
        }else{
            filterLabel.text = "3 Filtered"
        }
        searchCategory = true
        searchBrand = true
        clearButton.setTitle("Clear all", for: .normal)
        clearButton.isHidden = false
        first = false
    }
    
    func applyCategory(category: CategoriesModel, minPrice: Int?, maxPrice: Int?) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByCategories(categoriesId: category.categories_id!, minPrice: minPrice, maxPrice: maxPrice)
        filterView.isHidden = false
        filterLabel.text = "Category: \(category.categories_name ?? "")"
        searchCategory = true
        clearButton.setTitle("Clear all", for: .normal)
        clearButton.isHidden = false
        first = false
        
    }
    
    func applyBrand(brand: BrandModel, minPrice: Int?, maxPrice: Int?) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadByBrands(brandId: brand.brand_id!, minPrice: minPrice, maxPrice: maxPrice)
        filterView.isHidden = false
        filterLabel.text = "Brand: \(brand.brand_name ?? "")"
        searchBrand = true
        clearButton.setTitle("Clear all", for: .normal)
        clearButton.isHidden = false
        first = false
    }
    
    func applyPrice(minPrice: Int?, maxPrice: Int?) {
        loadingActivity.startAnimating()
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        if maxPrice == nil{
            downloadProduct.downloadByMinPrice(minPrice: minPrice!)
            filterLabel.text = "Minimum price: \(minPrice!)"
        }else if minPrice == nil{
            downloadProduct.downloadByMaxPrice(maxPrice: maxPrice!)
            filterLabel.text = "Maximum price: \(maxPrice!)"
        }

        else{
            downloadProduct.downloadByPrice(minPrice: minPrice!, maxPrice: maxPrice!)
            filterLabel.text = "Price: \(minPrice!) - \(maxPrice!)"
        }
        filterView.isHidden = false
        searchBrand = true
        clearButton.setTitle("Clear all", for: .normal)
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
    private var popularProduct: [ProductModel] = []
    
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
        
        let recentWord = UserDefaults.standard.array(forKey: "recent")
        if recentWord != nil{
            clearButton.isHidden = false
        }else{
            clearButton.isHidden = true
        }
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadSort(sort: 1)
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
            if !first{
                item = allProduct[itemIndex!]
            }else{
                item = popularProduct[itemIndex!]
            }
            
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
        if !first{
            return 1
        }else{
            return 2
            
        }
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
            let recentWord = UserDefaults.standard.array(forKey: "recent") as? [String]
            if section == 0 && recentWord != nil{
                self.tableView.separatorStyle = .singleLine
                return recentWord!.count
            }else if section == 1{
                return popularProduct.count
            }else{
                return 1
            }
            
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if allProduct.count > 0 && !searching{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
            
            let item = allProduct[indexPath.row]
            
            cell?.selectionStyle = .default
            cell?.productName.text = item.product_name
            cell?.categoryLabel.text = item.categories_name
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
            cell?.priceLabel.text = "\(formattedPrice ?? "")฿"
            
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
            cell?.categoryLabel.text = item.categories_name
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
            cell?.priceLabel.text = "\(formattedPrice ?? "")฿"
            
            if item.product_img != ""{
                cell?.productImg.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            }else{
                cell?.productImg.image = UIImage.init(named: "AppIcon")
            }
            return cell!
        }
        
        else{
                
            if first{
                var recentWord = UserDefaults.standard.array(forKey: "recent") as? [String]
                if recentWord != nil && indexPath.section == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchrecent")
                    recentWord?.reverse()
                    let item = recentWord?[indexPath.row]
                    cell?.textLabel!.text = item
                    return cell!
                    
                }
                else if indexPath.section == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath) as? SearchDetailTableViewCell
                    
                    let item = popularProduct[indexPath.row]
                    cell?.selectionStyle = .default
                    cell?.productName.text = item.product_name
                    cell?.categoryLabel.text = item.categories_name
                    let numberFormat = NumberFormatter()
                    numberFormat.numberStyle = .decimal
                    let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
                    cell?.priceLabel.text = "\(formattedPrice ?? "")฿"
                    
                    if item.product_img != ""{
                        cell?.productImg.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
                    }else{
                        cell?.productImg.image = UIImage.init(named: "AppIcon")
                    }
                    return cell!
                }
                
                else{
                    let searchingCell = tableView.dequeueReusableCell(withIdentifier: "NoItem", for: indexPath) as! NotifySearchDetailTableViewCell
                    
                    searchingCell.selectionStyle = .none
                    searchingCell.title.text = "Search Product"
                    searchingCell.notifyDescription.text = "Type your product name or filter the product item with category or brand"
                    return searchingCell
                }
                
                    
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
        if first && indexPath.section == 0{
            var recentWord = UserDefaults.standard.array(forKey: "recent") as? [String]
            recentWord?.reverse()
            searchBar.text = recentWord![indexPath.row]
            downloadProductByKeyword(keyword: searchBar.text!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let recentWord = UserDefaults.standard.array(forKey: "recent")
        if first{
            if section == 0 && recentWord != nil{
                return "Recent Search"
            }else if section == 0 && recentWord == nil{
                return nil
            }
            else{
                return "Most Popular"
            }
        }
        else{
            return nil
        }
    }
    
    private func downloadProductByKeyword(keyword: String){
        loadingActivity.startAnimating()
        let downloadProducts = DownloadProduct()
        downloadProducts.delegate = self
        downloadProducts.searchByKeyword(keyword.lowercased())
        clearButton.setTitle("Clear all", for: .normal)
        first = false
    }
    
    //MARK: - Tap clear
    @IBAction func tapClear(_ sender: Any) {
        if first{
            let alert = UIAlertController(title: "Clear Search Recent", message: "Do you want to clear search recent?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: {(action) -> Void in
                UserDefaults.standard.removeObject(forKey: "recent")
                self.clearButton.isHidden = true
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) -> Void in }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            clearSearch()
        }
    }
    
    var selectedCollectionCell: IndexPath!
    var previousSelect: IndexPath!

}

//MARK: - Category collection
extension SearchDetailTableViewController: DownloadProductProtocol{
    
    //MARK: - Search Finished
    func itemDownloaded(item: NSMutableArray){
        if !first{
            allProduct = item as! [ProductModel]
            setCountLabel(count: allProduct.count)
        }else{
            popularProduct = item as! [ProductModel]
        }
        
        self.tableView.reloadData()
        loadingActivity.stopAnimating()
        
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
    }
    
    private func clearSearch(){
        clearButton.setTitle("Clear Recent", for: .normal)
        let recentWord = UserDefaults.standard.array(forKey: "recent")
        if recentWord != nil{
            clearButton.isHidden = false
        }else{
            clearButton.isHidden = true
        }
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
                clearButton.isHidden = false
                first = false
                downloadProductByKeyword(keyword: searchBar.text!)
                
            }else{
                allProduct.removeAll()
                setCountLabel(count: 0)
                first = true
                self.tableView.reloadData()
                let recentWord = UserDefaults.standard.array(forKey: "recent")
                if recentWord != nil{
                    clearButton.isHidden = false
                }else{
                    clearButton.isHidden = true
                }
                clearButton.setTitle("Clear Recent", for: .normal)
            }
        }

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //Collect Recent Search
        var recentSearch = UserDefaults.standard.array(forKey: "recent") as? [String] ?? [String]()
        if recentSearch.count >= 5{
            recentSearch.remove(at: 0)
        }
        let searchbarText = searchBar.text
        if searchbarText != ""{
            recentSearch.append(searchbarText!)
            UserDefaults.standard.set(recentSearch, forKey: "recent")
        }
        
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
}
