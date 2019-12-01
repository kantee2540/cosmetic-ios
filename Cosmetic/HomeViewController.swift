//
//  HomeViewController.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, DownloadProductProtocol, DownloadTopicProtocol{
    func topicDownloaded(item: NSMutableArray) {
        topicItem = item as! [TopicModel]
        featuringCollection.reloadData()
        
    }
    
    func itemDownloaded(item: NSMutableArray) {
        removeSpinner()
        resultProductItem = item as! [ProductModel]
        topCollection.reloadData()
    }
    
    var resultProductItem : [ProductModel] = []
    var topicItem: [TopicModel] = []
    var session :URLSession!
    
    @IBOutlet weak var featuringCollection: UICollectionView!
    @IBOutlet weak var topCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
        
        self.showSpinner(onView: self.view)
        
        topCollection.delegate = self
        topCollection.dataSource = self
        featuringCollection.delegate = self
        featuringCollection.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadLimitItem(limitNum: 9)
        
        //downloadProduct()
        downloadTopic()
    }
    
    private func downloadProduct(){
        
    }
    
    private func downloadTopic(){
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.downloadItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Coco"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    //Round on corner
    func roundCorner(button :UIButton){
        button.layer.cornerRadius = 10
    }

    func getCollectionList(){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = topCollection.indexPathsForSelectedItems?.first?.item
            let item = resultProductItem[itemIndex!]
            destination?.productId = item.product_id
        }
    }

}

//MARK: - Lastest product collection
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollection{
            return resultProductItem.count
        }
        
        else if collectionView == featuringCollection {
            return topicItem.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        ///Lastest Product
        if collectionView == topCollection{
            let item: ProductModel = resultProductItem[indexPath.row]
            let collectionProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topViewCollectionCell", for: indexPath) as! TopCollectionViewCell
            
            collectionProductCell.topTitle.text = item.product_name
            collectionProductCell.topDescription.text = item.product_description
            let imageURL = URL(string: item.product_img!)!
            collectionProductCell.topImage.downloadImage(from: imageURL)
            
            collectionProductCell.contentView.layer.cornerRadius = 8
            collectionProductCell.contentView.layer.borderWidth = 1.0
            collectionProductCell.contentView.layer.borderColor =  UIColor.clear.cgColor
            collectionProductCell.contentView.layer.masksToBounds = true
            collectionProductCell.layer.cornerRadius = 8
            collectionProductCell.layer.shadowColor = UIColor.black.cgColor
            collectionProductCell.layer.shadowOffset = CGSize(width: 0, height: 3.0)
            collectionProductCell.layer.shadowRadius = 2
            collectionProductCell.layer.shadowOpacity = 0.1
            collectionProductCell.layer.masksToBounds = false
            
            return collectionProductCell
        }
            
        ///Today card
        else if collectionView == featuringCollection{
            let item = topicItem[indexPath.row]
            let featuringCell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuringReuse", for: indexPath) as! FeaturingCollectionViewCell
            
            featuringCell.topicTitle.text = item.topic_name
            featuringCell.topicTitle.layer.shadowColor = UIColor.black.cgColor
            featuringCell.topicTitle.layer.shadowOpacity = 0.5
            featuringCell.topicTitle.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            featuringCell.topicTitle.layer.shadowRadius = 3
            
            featuringCell.topicImage.image = UIImage(named: "bg4")
            
            featuringCell.contentView.layer.cornerRadius = 8
            featuringCell.contentView.layer.borderWidth = 1.0
            featuringCell.contentView.layer.borderColor =  UIColor.clear.cgColor
            featuringCell.contentView.layer.masksToBounds = true
            featuringCell.layer.cornerRadius = 8
            featuringCell.layer.shadowColor = UIColor.black.cgColor
            featuringCell.layer.shadowOffset = CGSize(width: 0, height: 3.0)
            featuringCell.layer.shadowRadius = 4
            featuringCell.layer.shadowOpacity = 0.2
            featuringCell.layer.masksToBounds = false
            
            return featuringCell
            
        }
        
        
        return cell
    }
    
}
