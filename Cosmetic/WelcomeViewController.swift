//
//  WelcomeViewController.swift
//  Cosmetic
//
//  Created by Omp on 26/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, CosmeticDetailDelegate, TopTopicDelegate {
    func dismissFromTopTopic() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }
    
    
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    @IBOutlet weak var tipofday: UIView!
    @IBOutlet weak var pickYouCollectionView: UICollectionView!
    @IBOutlet weak var setCollectionview: UICollectionView!
    @IBOutlet weak var startSearchTextfield: UITextField!
    private var pickForYouProduct: [ProductModel] = []
    private var recommendedSet: [TopicModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        startSearchTextfield.delegate = self
        tipofday.layer.cornerRadius = 6
        
        pickYouCollectionView.delegate = self
        pickYouCollectionView.dataSource = self
        setCollectionview.delegate = self
        setCollectionview.dataSource = self
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadLimitItem(limitNum: 10)
        
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.downloadLimitTopic(limit: 4)
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Coco"
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Seemoredetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = pickYouCollectionView.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = pickForYouProduct[itemIndex!]
            destination?.productId = item.product_id
        }else if segue.identifier == "Seetopic"{
            let destination = segue.destination as? TopTopicViewController
            let itemIndex = setCollectionview.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = recommendedSet[itemIndex!]
            destination?.topicId = item.topic_id
            destination?.topicImg = item.topic_img
            destination?.topicDescription = item.topic_description
            destination?.topicName = item.topic_name
        }
    }

}

extension WelcomeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEditing = false
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchDetailView")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol, DownloadTopicProtocol{
    func topicDownloaded(item: NSMutableArray) {
        recommendedSet = item as! [TopicModel]
        setCollectionview.reloadData()
    }
    
    func itemDownloaded(item: NSMutableArray) {
        pickForYouProduct = item as! [ProductModel]
        pickYouCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pickYouCollectionView{
            return pickForYouProduct.count
        }else if collectionView == setCollectionview{
            return recommendedSet.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  pickYouCollectionView{
            let pickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickcell", for: indexPath) as! PickforyouCollectionViewCell
            let item = pickForYouProduct[indexPath.row]
            pickCell.layer.cornerRadius = 5
            pickCell.productName.text = item.product_name
            pickCell.productBrand.text = item.brand_name
            if item.product_img != ""{
                pickCell.productImage.downloadImage(from: URL(string: item.product_img!)!)
            }else{
                pickCell.productImage.image = UIImage.init(named: "bg4")
            }
            return pickCell
        }
        else if collectionView == setCollectionview{
            let setCell = collectionView.dequeueReusableCell(withReuseIdentifier: "setcell", for: indexPath) as! SetCollectionViewCell
            let item = recommendedSet[indexPath.row]
            setCell.layer.cornerRadius = 5
            if item.topic_img != ""{
                setCell.setImage.downloadImage(from: URL(string: item.topic_img ?? "")!)
            }else{
                setCell.setImage.image = UIImage.init(named: "bg4")
            }
            
            setCell.setName.text = item.topic_name
            return setCell
        }else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    
    
}
