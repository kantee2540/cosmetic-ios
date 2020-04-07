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

class SearchFilterTableViewController: UITableViewController, DownloadBrandProtocol, DownloadCategoriesProtocol {
    func itemDownloadedBrands(item: NSMutableArray) {
        loadingActivity.stopAnimating()
        brandsList = item as! [BrandModel]
        self.tableView.reloadData()
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        loadingActivity.stopAnimating()
        categoriesList = item as! [CategoriesModel]
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var optionSegment: UISegmentedControl!
    @IBOutlet weak var applyButton: UIBarButtonItem!
    
    var delegate: SearchFilterTableViewControllerDelegate?
    var brandFilter :Bool = false
    var categoryFilter: Bool = false
    private var brandsList: [BrandModel] = []
    private var categoriesList: [CategoriesModel] = []
    private var selectedCategory: CategoriesModel?
    private var selectedBrand: BrandModel?
    
    override func viewDidLoad() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
            return categoriesList.count
        }else{
            return brandsList.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if categoryFilter{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SearchFilterTableViewCell
            let item = categoriesList[indexPath.row]
            cell.textLabel?.text = item.categories_name
            cell.detailTextLabel?.text = item.categories_type
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BrandCell", for: indexPath) as! SearchFilterBrandTableViewCell
            let item = brandsList[indexPath.row]
            cell.brandName.text = item.brand_name
            cell.brandLogo.downloadImage(from: URL(string: item.brand_logo!)!)
            
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        applyButton.isEnabled = true
        if brandFilter{
            let item = brandsList[indexPath.row]
            selectedBrand = item
        }else{
            let item = categoriesList[indexPath.row]
            selectedCategory = item
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

}
