//
//  HomeTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 5/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, DownloadCategoriesProtocol {
    
    var resultCategoriesItem : [CategoriesModel] = []
    var resultProductItem : [ProductModel] = []
    @IBOutlet weak var collectionCategories: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCategories.delegate = self
        collectionCategories.dataSource = self
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()
        
        
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.navigationItem.title = "Home"
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func itemDownloaded(item: NSMutableArray) {
        resultCategoriesItem = item as! [CategoriesModel]
        collectionCategories.reloadData()
    }

}

extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCategoriesItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item :CategoriesModel = resultCategoriesItem[indexPath.row]
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath) as! HomeCollectionViewCell
        collectionCell.categoriesName.text = item.categories_name
        
        collectionCell.layer.cornerRadius = 5
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "cosmeticCollection")) as? CosmeticCollectionTableViewController
        vc?.categories_id = resultCategoriesItem[indexPath.row].categories_id
        vc?.categories_name = resultCategoriesItem[indexPath.row].categories_name
        navigationController?.pushViewController(vc!, animated: true)
    }
}
