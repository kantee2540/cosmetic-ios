//
//  HomeViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, DownloadCategoriesProtocol{
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [CategoriesModel]
        collection.reloadData()
        self.removeSpinner()
    }
    
    var resultItem : [CategoriesModel] = []
    let itemCollection = ["Lips", "Face", "Eyes", "Nails"]
    @IBOutlet weak var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        collection.delegate = self
        collection.dataSource = self
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
        
        self.showSpinner(onView: self.view)
        let downloadCategories = DownloadCategories()
        downloadCategories.delegate = self
        downloadCategories.downloadItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Home"
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    //Round on corner
    func roundCorner(button :UIButton){
        button.layer.cornerRadius = 10
    }

    func getCollectionList(){
        
    }
    

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item :CategoriesModel = resultItem[indexPath.row]
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollection", for: indexPath) as! HomeCollectionViewCell
    
        collectionCell.collectionLabel.text = item.categories_name
        collectionCell.layer.cornerRadius = 8
        
        //Color
        
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "cosmeticCollection")) as? CosmeticCollectionTableViewController
        vc?.categories_id = resultItem[indexPath.row].categories_id
        vc?.categories_name = resultItem[indexPath.row].categories_name
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
}

var vSpinnerHome :UIView?
extension HomeViewController{
    func showSpinner(onView :UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinnerHome = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinnerHome?.removeFromSuperview()
            vSpinnerHome = nil
        }
    }
}
