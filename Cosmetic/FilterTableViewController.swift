//
//  FilterTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 2/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol FilterTableViewControllerDelegate {
    func applyFilter(brand: BrandModel, category: CategoriesModel)
    func applyCategory(category: CategoriesModel)
    func applyBrand(brand: BrandModel)
}

class FilterTableViewController: UITableViewController {
    
    var delegate: FilterTableViewControllerDelegate?
    
    private var brandItem: [BrandModel] = []
    private var categoriesItem: [CategoriesModel] = []
    
    private var selectedBrand: BrandModel!
    private var selectedCategory: CategoriesModel!
    
    @IBOutlet weak var applyButton: UIBarButtonItem!
    @IBOutlet weak var brandCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        downloadBrand()
        downloadCategories()
        
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    @IBAction func tapApply(_ sender: Any) {
        if selectedCategory != nil && selectedBrand != nil{
            delegate?.applyFilter(brand: selectedBrand, category: selectedCategory)
        }else if selectedCategory != nil && selectedBrand == nil{
            delegate?.applyCategory(category: selectedCategory)
        }else if selectedCategory == nil && selectedBrand != nil{
            delegate?.applyBrand(brand: selectedBrand)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension FilterTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadBrandProtocol, DownloadCategoriesProtocol{
    
    func itemDownloadedBrands(item: NSMutableArray) {
        brandItem = item as! [BrandModel]
        brandCollectionView.reloadData()
        
    }
    
    func itemDownloadedCategories(item: NSMutableArray) {
        categoriesItem = item as! [CategoriesModel]
        categoriesCollectionView.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == brandCollectionView{
            return brandItem.count
        }else{
            return categoriesItem.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandcell", for: indexPath) as! FilterCollectionViewCell
            let item = brandItem[indexPath.row]
            cell.layer.cornerRadius = 8
            cell.filterLabel.text = item.brand_name
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriescell", for: indexPath) as! FilterCollectionViewCell
            let item = categoriesItem[indexPath.row]
            cell.layer.cornerRadius = 8
            cell.filterLabel.text = item.categories_name
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        applyButton.isEnabled = true
        if collectionView == brandCollectionView{
            let item = brandItem[indexPath.row]
            if selectedBrand != nil{
                if selectedBrand.brand_id != item.brand_id{
                    selectedBrand = item
                }else{
                    selectedBrand = nil
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }else{
                selectedBrand = item
            }
            
        }else{
            let item = categoriesItem[indexPath.row]
            if selectedCategory != nil{
                if selectedCategory.categories_id != item.categories_id{
                    selectedCategory = item
                }else{
                    selectedCategory = nil
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
            else{
                selectedCategory = item
            }
        }
        
        if selectedCategory == nil && selectedBrand == nil{
            applyButton.isEnabled = false
        }
    }
    
}
