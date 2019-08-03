//
//  HomeViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, DownloadCategoriesProtocol, DownloadLastestProductProtocol{
    func itemDownloadedProductLastest(item: NSMutableArray) {
        resultProductItem = item as! [ProductModel]
        topCollection.reloadData()
    }
    
    func itemDownloaded(item: NSMutableArray) {
        resultItem = item as! [CategoriesModel]
        collection.reloadData()
        self.removeSpinner()
    }
    
    var resultItem : [CategoriesModel] = []
    var resultProductItem : [ProductModel] = []
    var session :URLSession!
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var topCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        collection.delegate = self
        collection.dataSource = self
        topCollection.delegate = self
        topCollection.dataSource = self
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
        
        self.showSpinner(onView: self.view)
        
        let downloadProductLastest = DownloadProductLastest()
        downloadProductLastest.delegate = self
        downloadProductLastest.downloadItem()
        
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraCaptureRoot")
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
        if collectionView == collection{
            return resultItem.count
        }
        if collectionView == topCollection{
            return resultProductItem.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        if collectionView == collection{
            let item :CategoriesModel = resultItem[indexPath.row]
            let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollection", for: indexPath) as! HomeCollectionViewCell
        
            collectionCell.collectionLabel.text = item.categories_name
            collectionCell.layer.cornerRadius = 8
            
            return collectionCell
        }
        
        if collectionView == topCollection{
            let item: ProductModel = resultProductItem[indexPath.row]
            let collectionProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topViewCollectionCell", for: indexPath) as! TopCollectionViewCell
            
            collectionProductCell.topTitle.text = item.product_name
            collectionProductCell.topDescription.text = item.product_description
            let imageURL = URL(string: item.product_img!)
            
            DispatchQueue.global().async {
                self.session = URLSession(configuration: .default)
                
                let getImageFromUrl = self.session.dataTask(with: imageURL!) { data, responds, error in
                    if let e = error{
                        print("Error = \(e)")
                    }
                    else {
                        if (responds as? HTTPURLResponse) != nil {
                            if let imageData = data {
                                
                                DispatchQueue.main.async {
                                    collectionProductCell.topImage.image = UIImage(data: imageData)
                                    collectionProductCell.topImage.clipsToBounds = true
                                }
                            }
                            else{
                                print("Image file is currupted")
                            }
                        }
                        else{
                            print("No response from server")
                        }
                    }
                }
                
                getImageFromUrl.resume()
            }
            
            collectionProductCell.contentView.layer.cornerRadius = 15
            collectionProductCell.contentView.layer.borderWidth = 1.0
            collectionProductCell.contentView.layer.borderColor =  UIColor.clear.cgColor
            collectionProductCell.contentView.layer.masksToBounds = true
            collectionProductCell.layer.cornerRadius = 15
            collectionProductCell.layer.shadowColor = UIColor.lightGray.cgColor
            collectionProductCell.layer.shadowOffset = CGSize(width: 0, height: 5.0)
            collectionProductCell.layer.shadowRadius = 10
            collectionProductCell.layer.shadowOpacity = 1.0
            collectionProductCell.layer.masksToBounds = false
            
            return collectionProductCell
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collection{
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "cosmeticCollection")) as? CosmeticCollectionTableViewController
            let item: CategoriesModel = resultItem[indexPath.row]
            vc?.categories_id = item.categories_id
            vc?.categories_name = item.categories_name
            navigationController?.pushViewController(vc!, animated: true)
        }
        
        if collectionView == topCollection{
            let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "CosmeticInfoView") as! CosmeticInfoViewController
            let item :ProductModel = resultProductItem[indexPath.row]
            
            infoVC.product_name = item.product_name
            infoVC.product_description = item.product_description
            infoVC.product_price = item.product_price
            infoVC.categories_name = item.categories_name
            infoVC.brand_name = item.brand_name
            infoVC.product_img = item.product_img
            navigationController?.pushViewController(infoVC, animated: true)
            
        }
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
