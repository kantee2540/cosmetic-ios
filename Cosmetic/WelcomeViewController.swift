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

    @IBOutlet weak var startSearchview: UIView!
    @IBOutlet weak var pickforyouload: UIActivityIndicatorView!
    @IBOutlet weak var recommendsetload: UIActivityIndicatorView!
    @IBOutlet weak var deskload: UIActivityIndicatorView!
    @IBOutlet weak var cosmeticDeskTitle: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var cosmeticdeskCollectionview: UICollectionView!
    @IBOutlet weak var pickYouCollectionView: UICollectionView!
    @IBOutlet weak var setCollectionview: UICollectionView!
    
    private var cosmeticList: [CosmeticDeskModel] = []
    private var pickForYouProduct: [ProductModel] = []
    private var recommendedSet: [TopicModel] = []
    private var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        startSearchview.layer.cornerRadius = 8
        
        pickYouCollectionView.delegate = self
        pickYouCollectionView.dataSource = self
        setCollectionview.delegate = self
        setCollectionview.dataSource = self
        cosmeticdeskCollectionview.delegate = self
        cosmeticdeskCollectionview.dataSource = self
        
        self.scrollview.addSubview(self.refreshControl)
        downloadContent()
    }
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlerRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc private func handlerRefresh(_ refreshControl: UIRefreshControl){
        downloadContent()
        
    }
    
    private func downloadContent(){
        pickforyouload.isHidden = false
        recommendsetload.isHidden = false
        
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadLimitItem(limitNum: 10)
        
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.downloadLimitTopic(limit: 4)
        
        if userId != nil{
            downloadCosmeticDeskList()
        }
    }
    
    private func downloadCosmeticDeskList(){
        
        let downloadCosmeticDesk = DownloadCosmeticDeskList()
        downloadCosmeticDesk.delegate = self
        downloadCosmeticDesk.getCosmeticByLimit(userId: userId ?? "", limit: 5)
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Coco"
        tabBarController?.navigationItem.leftBarButtonItem = nil
        
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        
        if userId == nil{
            cosmeticdeskCollectionview.visibility = .gone
            cosmeticDeskTitle.visibility = .gone
            deskload.visibility = .gone
        }else{
            downloadCosmeticDeskList()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
    }
    
    //MARK: - Prepare for another viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Seemoredetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = pickYouCollectionView.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = pickForYouProduct[itemIndex!]
            destination?.productId = item.product_id
            
        }else if segue.identifier == "Seemoredetailfromdesk"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = cosmeticdeskCollectionview.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = cosmeticList[itemIndex!]
            destination?.productId = item.product_id
        }
        
        else if segue.identifier == "Seetopic"{
            let destination = segue.destination as? TopTopicViewController
            let itemIndex = setCollectionview.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = recommendedSet[itemIndex!]
            destination?.topicId = item.topic_id
        }
    }

}

extension WelcomeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchDetailView")
        self.navigationController?.pushViewController(vc!, animated: true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol, DownloadTopicProtocol, DownloadCosmeticDeskListDelegate{
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        cosmeticList = item as! [CosmeticDeskModel]
        cosmeticdeskCollectionview.reloadData()
        
        if cosmeticList.count > 0{
            cosmeticdeskCollectionview.visibility = .visible
            cosmeticDeskTitle.visibility = .visible
            deskload.visibility = .visible
        }else{
            cosmeticdeskCollectionview.visibility = .gone
            cosmeticDeskTitle.visibility = .gone
            deskload.visibility = .gone
        }
        
        deskload.isHidden = true
    }
    
    func itemCosmeticDeskFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
        deskload.isHidden = true
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
        refreshControl.endRefreshing()
        pickforyouload.isHidden = true
    }
    
    func topicDownloaded(item: NSMutableArray) {
        recommendedSet = item as! [TopicModel]
        setCollectionview.reloadData()
        recommendsetload.isHidden = true
    }
    
    func topicError(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
        recommendsetload.isHidden = true
    }
    
    func itemDownloaded(item: NSMutableArray) {
        pickForYouProduct = item as! [ProductModel]
        pickYouCollectionView.reloadData()
        pickforyouload.isHidden = true
        refreshControl.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == pickYouCollectionView{
            return pickForYouProduct.count
        }else if collectionView == setCollectionview{
            return recommendedSet.count
        }else if collectionView == cosmeticdeskCollectionview && userId != nil{
            return cosmeticList.count
        }
        else{
            return 0
        }
    }
    
    //MARK: - Fetch item to collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  pickYouCollectionView{
            let pickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickcell", for: indexPath) as! PickforyouCollectionViewCell
            let item = pickForYouProduct[indexPath.row]
            pickCell.layer.cornerRadius = 5
            pickCell.productName.text = item.product_name
            pickCell.productBrand.text = item.brand_name
            if item.product_img != ""{
                pickCell.productImage.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
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
                setCell.setImage.downloadImage(from: URL(string: item.topic_img ?? "") ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            }else{
                setCell.setImage.image = UIImage.init(named: "bg4")
            }
            
            setCell.setName.text = item.topic_name
            return setCell
            
        }else if collectionView == cosmeticdeskCollectionview && userId != nil{
            let pickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "deskcell", for: indexPath) as! PickforyouCollectionViewCell
            let item = cosmeticList[indexPath.row]
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
        
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
