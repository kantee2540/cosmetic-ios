//
//  CosmeticDeskViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CosmeticDeskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var deskView: UIView!
    @IBOutlet weak var noCosmetic: UILabel!
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countTopic: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var deskCollection: UICollectionView!
    @IBOutlet weak var menuSegment: UISegmentedControl!
    
    private var deskList: [CosmeticDeskModel] = []
    private var saveTopic: [TopicModel] = []
    private var userId: String?
    private var spinnerIsShow: Bool = false
    
    lazy var deskRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlerRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc private func handlerRefresh(_ refreshControl: UIRefreshControl){
        if menuSegment.selectedSegmentIndex == 0{
            downloadDesk()
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList()
        }else if menuSegment.selectedSegmentIndex == 2{
            downloadBeautySet()
        }
        
    }
    
    //MARK: - Number of item in collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
            return deskList.count
        }else{
            return saveTopic.count
        }
        
    }
    
    //MARK: - Fetch item to cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
            let deskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartitem", for: indexPath) as! DeskCollectionViewCell
            let item = deskList[indexPath.row]
            deskCell.delegate = self
            
            deskCell.deskId = item.desk_id
            deskCell.productId = item.product_id
            deskCell.userId = userId
            deskCell.indexPath = indexPath
            
            deskCell.productName.text = item.product_name
            deskCell.productImage.downloadImage(from: URL(string: item.product_img!)!)
            deskCell.brand.text = item.brand_name?.uppercased()
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price!))
            deskCell.productPrice.text = "\(formattedPrice!)฿"
            
            if item.favorite == "1"{
                deskCell.favoriteStatus = true
                deskCell.setHeartFill()
            }else{
                deskCell.favoriteStatus = false
                deskCell.setHeartOutlined()
            }
            
            deskCell.layer.cornerRadius = 8
            
            return deskCell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savetopic", for: indexPath) as! BeautySetCollectionViewCell
            cell.layer.cornerRadius = 8
            let item = saveTopic[indexPath.row]
            if item.topic_img != ""{
                cell.topicImage.downloadImage(from: URL(string: item.topic_img!)!)
            }
            cell.topicName.text = item.topic_name
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    //MARK: - Change segment
    @IBAction func changeMenuSegment(_ sender: Any) {
        showSpinner(onView: self.view)
        if menuSegment.selectedSegmentIndex == 0{
            downloadCosmeticList()
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList()
        }
        else if menuSegment.selectedSegmentIndex == 2{
            downloadBeautySet()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.updateViewConstraints()
        self.collectionHeight.constant = deskCollection.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    //MARK: - Didload
    override func viewDidLoad() {
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        if userId != nil{
            showSpinner(onView: self.view)
            spinnerIsShow = true
        }
        
        scrollview.addSubview(deskRefreshControl)
    }
    
    //MARK: - willAppear
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "My Desk"
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        
        if userId != nil{
            downloadDesk()
            downloadBeautySet()
            let profileurl = UserDefaults.standard.string(forKey: ConstantUser.profilepic)
            let email = UserDefaults.standard.string(forKey: ConstantUser.email)
            
            profilepic.makeRounded()
            if profileurl != ""{
                profilepic.downloadImage(from: URL(string: profileurl!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            }else{
                profilepic.image = UIImage(systemName: "person.crop.circle.fill")
            }
            
            emailLabel.text = email
            
        }else{
            deskList.removeAll()
            deskCollection.reloadData()
        }
    }
    
    private func downloadDesk(){
        if menuSegment.selectedSegmentIndex == 0{
            downloadCosmeticList()
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList()
        }
        welcomeNameLabel.text = UserDefaults.standard.string(forKey: ConstantUser.nickName)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        deskCollection.delegate = self
        deskCollection.dataSource = self
        
        let nologinVc = (self.storyboard?.instantiateViewController(identifier: "nologin")) as! NoLoginViewController
        let viewControllers: [UIViewController] = self.children
        if userId != nil{
            for vcs in viewControllers{
                vcs.willMove(toParent: nil)
                vcs.view.removeFromSuperview()
                vcs.removeFromParent()
            }
        }else{
            add(nologinVc)
        }
    }
    
    //MARK: - Go to another viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = deskCollection.indexPathsForSelectedItems?.first
            let item = deskList[itemIndex!.row]
            destination?.delegate = self
            destination?.productId = item.product_id
            
         }else if segue.identifier == "showtopic"{
            let destination = segue.destination as? TopTopicViewController
            let itemindex = deskCollection.indexPathsForSelectedItems?.first
            let item = saveTopic[itemindex!.row]
            destination?.topicId = item.topic_id
            
        }
    }
    
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }
    
    private func downloadCosmeticList(){
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getCosmeticDeskByUserid(userId: userId!)
    }
    
    private func downloadFavoriteList(){
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getFavorite(userId: userId!)
    }
    
    private func downloadBeautySet(){
        let downloadSaveTopic = DownloadSaveTopic()
        downloadSaveTopic.delegate = self
        downloadSaveTopic.downloadSaveTopic(userId: userId!)
    }

}

extension CosmeticDeskViewController: DownloadCosmeticDeskListDelegate, DeskCollectionViewCellDelegate, CosmeticDeskDelegate, CosmeticDetailDelegate, DownloadSaveTopicDelegate{
    func downloadSaveTopicSuccess(item: NSMutableArray) {
        saveTopic = item as! [TopicModel]
        countTopic.text = "\(saveTopic.count)"
        deskCollection.reloadData()
        removeSpinner()
        deskRefreshControl.endRefreshing()
    }
    
    func downloadSaveTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    //MARK: - Tap Action from cosmetic desk item
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath, button: UIButton) {
        let item = deskList[indexPath.row]
        
        let deskItemAction = UIAlertController(title: item.product_name, message: "Do you want to do next?", preferredStyle: .actionSheet)
        deskItemAction.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            
            let productId: String = item.product_id!
            let getAddress = webAddress()
            let url = URL(string: getAddress.getrootURL() + "?cosmeticid=\(productId)")
            
            let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
            
            //For iPad
            if let popoverController = activityViewController.popoverPresentationController{
                popoverController.sourceView = button
                popoverController.sourceRect = button.bounds
            }
            
            self.present(activityViewController, animated: true, completion: nil)
            
        }))
        
        deskItemAction.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            (UIAlertAction) in
            //Delete this product item
            self.showSpinner(onView: self.view)
            let cosmeticDesk = CosmeticDesk()
            cosmeticDesk.delegate = self
            cosmeticDesk.deleteFromDesk(productId: productId, userId: userId)
        }))
        
        if let popoverController = deskItemAction.popoverPresentationController{
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        deskItemAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
        self.present(deskItemAction, animated: true, completion: nil)
    }
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        deskList = item as! [CosmeticDeskModel]
        if deskList.count > 0{
            noCosmetic.text = ""
            noCosmetic.isHidden = true
            
        }else{
            noCosmetic.text = "No cosmetic in your desk"
            noCosmetic.isHidden = false
        }
        
        if menuSegment.selectedSegmentIndex == 0{
            countLabel.text = "\(deskList.count)"
        }
        
        deskCollection.reloadData()
        removeSpinner()
        deskRefreshControl.endRefreshing()
    }
    
    func itemCosmeticDeskFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
        removeSpinner()
        deskRefreshControl.endRefreshing()
    }
    
    func onSuccess() {
        downloadCosmeticList()
    }
    
    func onFailed() {
        
    }
}
