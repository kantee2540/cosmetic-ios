//
//  SearchFilterTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 6/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
protocol SearchFilterTableViewControllerDelegate {
    func filterResultCategory(item: CategoriesModel)
    func filterResultBrand(item: BrandModel)
}

class SearchFilterTableViewController: UITableViewController, DownloadBrandProtocol, DownloadCategoriesProtocol, UISearchBarDelegate {
    func itemDownloadedBrands(item: NSMutableArray) {
        loadingActivity.stopAnimating()
        brandsList = item as! [BrandModel]
        searchBar.placeholder = "Search Brand"
        self.tableView.reloadData()
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        loadingActivity.stopAnimating()
        categoriesList = item as! [CategoriesModel]
        searchBar.placeholder = "Search Category"
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var optionSegment: UISegmentedControl!
    @IBOutlet weak var applyButton: UIBarButtonItem!
    private var searchBar: UISearchBar!
    
    var delegate: SearchFilterTableViewControllerDelegate?
    var brandFilter :Bool = false
    var categoryFilter: Bool = false
    
    private var brandsList: [BrandModel] = []
    private var categoriesList: [CategoriesModel] = []
    
    private var searchedBrandsList: [BrandModel] = []
    private var searchedCategoriesList: [CategoriesModel] = []
    
    private var selectedCategory: CategoriesModel?
    private var selectedBrand: BrandModel?
    
    private var searching: Bool = false
    
    override func viewDidLoad() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        loadingActivity.startAnimating()
        super.viewDidLoad()
        if categoryFilter{
            downloadCategories()
            optionSegment.selectedSegmentIndex = 0
        }else{
            downloadBrand()
            optionSegment.selectedSegmentIndex = 1
        }
    }
    
    private func downloadBrand(){
        let downloadBrand = DownloadBrands()
        downloadBrand.delegate = self
        downloadBrand.downloadItem()
    }

    private func downloadCategories(){
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if categoryFilter{
            if searching && searchedCategoriesList.count > 0{
                return searchedCategoriesList.count
            }
            else if searching && searchedCategoriesList.count == 0{
                return 1
            }
                
            else{
                return categoriesList.count
            }
        }else{
            if searching && searchedBrandsList.count > 0{
                return searchedBrandsList.count
            }
            else if searching && searchedBrandsList.count == 0{
                return 1
            }
                
            else{
                return brandsList.count
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if categoryFilter{
            
            var identifierCell: String!
            if searchedCategoriesList.count > 0{
                identifierCell = "CategoryCell"
            }
            else if !searching{
                identifierCell = "CategoryCell"
            }
            else{
                identifierCell = "itemnotfound"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath)
            
            var item: CategoriesModel!
            if searching && searchedCategoriesList.count > 0{
                item = searchedCategoriesList[indexPath.row]
                cell.textLabel?.text = item.categories_name
                cell.detailTextLabel?.text = item.categories_type
            }else if !searching{
                item = categoriesList[indexPath.row]
                cell.textLabel?.text = item.categories_name
                cell.detailTextLabel?.text = item.categories_type
            }
            
            
            return cell
        }else{
            var identifierCell: String!
            if searchedBrandsList.count > 0{
                identifierCell = "BrandCell"
            }
            else if !searching{
                identifierCell = "BrandCell"
            }
            
            else{
                identifierCell = "itemnotfound"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierCell, for: indexPath) as! SearchFilterBrandTableViewCell
            
            var item: BrandModel!
            if searching && searchedBrandsList.count > 0{
                item = searchedBrandsList[indexPath.row]
                cell.brandName.text = item.brand_name
                cell.brandLogo.downloadImage(from: URL(string: item.brand_logo!)!)
            }
            else if !searching{
                item = brandsList[indexPath.row]
                cell.brandName.text = item.brand_name
                cell.brandLogo.downloadImage(from: URL(string: item.brand_logo!)!)
            }
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        applyButton.isEnabled = true
        if brandFilter{
            if searching{
                let item = searchedBrandsList[indexPath.row]
                selectedBrand = item
            }else{
                let item = brandsList[indexPath.row]
                selectedBrand = item
            }
        }else{
            if searching{
                let item = searchedCategoriesList[indexPath.row]
                selectedCategory = item
            }else{
                let item = categoriesList[indexPath.row]
                selectedCategory = item
            }
            
        }
    }
    
    
    @IBAction func tapApply(_ sender: Any) {
        if brandFilter{
            delegate?.filterResultBrand(item: selectedBrand!)
        }else{
            delegate?.filterResultCategory(item: selectedCategory!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func optionChange(_ sender: Any) {
        loadingActivity.startAnimating()
        searching = false
        searchBar.text = ""
        applyButton.isEnabled = false
        if optionSegment.selectedSegmentIndex == 0{
            brandFilter = false
            categoryFilter = true
            downloadCategories()
        }else{
            brandFilter = true
            categoryFilter = false
            downloadBrand()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0{
            searching = true
            if categoryFilter{
                searchedCategoriesList = categoriesList.filter(){
                    return ($0.categories_name?.lowercased() ?? "").contains(searchText.lowercased())
                }
            }else{
                searchedBrandsList = brandsList.filter(){
                    return ($0.brand_name?.lowercased() ?? "").contains(searchText.lowercased())
                }
            }
        }else{
            searching = false
        }
        self.tableView.reloadData()
    }

}
