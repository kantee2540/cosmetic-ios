//
//  SearchDetailTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/10/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class SearchDetailTableViewController: UITableViewController {

    var allProduct: [ProductModel]!
    private var searchedProduct: [ProductModel]!
    private var searching :Bool = false
    @IBOutlet var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Cosmetic"
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }
        if(section == 0 && searching){
            return 0
        }
        if(section == 1 && searching){
            return searchedProduct.count
        }
        else{
            return allProduct.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesReuse", for: indexPath)
            return cell
        }
        
        if(indexPath.section == 1 && searching){
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath)
            let item = searchedProduct[indexPath.row]
            cell.textLabel?.text = item.product_name
            return cell
        }
            
        else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultReuse", for: indexPath)
            let item = allProduct[indexPath.row]
            cell.textLabel?.text = item.product_name
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:ProductModel
        let infoVC = storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
        if searching{
            item = searchedProduct[indexPath.row]
        }else{
            item = allProduct[indexPath.row]
        }
        
        
        infoVC.product_name = item.product_name
        infoVC.product_description = item.product_description
        infoVC.product_price = item.product_price
        infoVC.categories_name = item.categories_name
        infoVC.brand_name = item.brand_name
        infoVC.product_img = item.product_img
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(infoVC, animated: true)
    }

}

extension SearchDetailTableViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("x")
        
        searchedProduct = allProduct.filter(){
            return ($0.product_name ?? "").contains(searchText)
        }
        if(searchText.count != 0){
            searching = true
        }else{
            searching = false
        }
        searchTable.reloadData()

    }
}
