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
    
    @IBOutlet weak var noItemIcon: UIImageView!
    @IBOutlet weak var noItemview: UIView!
    @IBOutlet weak var noItemLabel: UILabel!
    @IBOutlet weak var noItemDetail: UILabel!
    
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countTopic: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var deskCollection: UICollectionView!
    @IBOutlet weak var sortCollection: UICollectionView!
    @IBOutlet weak var menuSegment: UISegmentedControl!
    
    private var sortList: [String] = ["Most Recent", "A-Z", "Most View", "Price"]
    private var topicSortList: [String] = ["Most Recent", "A-Z", "Most View"]
    private var deskList: [CosmeticDeskModel] = []
    private var saveTopic: [TopicModel] = []
    private var uid: String?
    private var spinnerIsShow: Bool = false
    
    lazy var deskRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handlerRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @objc private func handlerRefresh(_ refreshControl: UIRefreshControl){
        if menuSegment.selectedSegmentIndex == 0{
            refreshData()
        }else if menuSegment.selectedSegmentIndex == 1{
            refreshData()
        }else if menuSegment.selectedSegmentIndex == 2{
            refreshData()
        }
        
    }
    
    //MARK: - Number of item in collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == sortCollection{
            if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
                return sortList.count
            }else{
                return topicSortList.count
            }
            
        }
        
        else{
            if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
                return deskList.count
            }else{
                return saveTopic.count
            }
        }
        
    }
    
    //MARK: - Fetch item to cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sortCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sortcell", for: indexPath) as! SortListCollectionViewCell
            var item: String = ""
            if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
                item = sortList[indexPath.row]
            }else{
                item = topicSortList[indexPath.row]
            }
            
            cell.sortLabel.text = item
            return cell
        }
        else{
            if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
                let deskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartitem", for: indexPath) as! DeskCollectionViewCell
                let item = deskList[indexPath.row]
                deskCell.delegate = self
                
                deskCell.deskId = item.desk_id
                deskCell.productId = item.product_id
                deskCell.indexPath = indexPath
                
                deskCell.productName.text = item.product_name
                deskCell.productImage.downloadImage(from: URL(string: item.product_img!)!)
                deskCell.brand.text = item.brand_name?.uppercased()
                let numberFormat = NumberFormatter()
                numberFormat.numberStyle = .decimal
                let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price!))
                deskCell.productPrice.text = "\(formattedPrice!)฿"
                
                if item.favorite == 1{
                    deskCell.favoriteStatus = true
                    deskCell.setHeartFill()
                }else{
                    deskCell.favoriteStatus = false
                    deskCell.setHeartOutlined()
                }
                
                return deskCell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savetopiccell", for: indexPath) as! BeautySetCollectionViewCell
                cell.delegate = self
                cell.indexPath = indexPath
                let item = saveTopic[indexPath.row]
                if item.topic_img != ""{
                    cell.topicImage.downloadImage(from: URL(string: item.topic_img!)!)
                }
                cell.topicName.text = item.topic_name
                return cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == deskCollection{
            collectionView.deselectItem(at: indexPath, animated: true)
        }else if collectionView == sortCollection{
            var order: String = ""
            
            if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
                switch indexPath.row {
                case 0: order = "recent"
                case 1: order = "a-z"
                case 2: order = "view"
                case 3: order = "price"
                default: downloadCosmeticList(orderBy: "recent")
                }
            }else if menuSegment.selectedSegmentIndex == 2{
                switch indexPath.row {
                case 0: order = "recent"
                case 1: order = "a-z"
                case 2: order = "view"
                default: downloadCosmeticList(orderBy: "recent")
                }
            }
            
            if menuSegment.selectedSegmentIndex == 0{
                downloadCosmeticList(orderBy: order)
            }else if menuSegment.selectedSegmentIndex == 1{
                downloadFavoriteList(orderBy: order)
            }else if menuSegment.selectedSegmentIndex == 2{
                downloadBeautySet(orderBy: order)
            }
        }
    }
    
    //MARK: - Change segment
    @IBAction func changeMenuSegment(_ sender: Any) {
        showSpinner(onView: self.view)
        sortCollection.reloadData()
        sortCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        if menuSegment.selectedSegmentIndex == 0{
            downloadCosmeticList(orderBy: "recent")
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList(orderBy: "recent")
        }
        else if menuSegment.selectedSegmentIndex == 2{
            downloadBeautySet(orderBy: "recent")
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
        
        sortCollection.delegate = self
        sortCollection.dataSource = self
        deskCollection.delegate = self
        deskCollection.dataSource = self
        
        uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        if uid != nil{
            showSpinner(onView: self.view)
            spinnerIsShow = true
        }
        
        scrollview.addSubview(deskRefreshControl)
    }
    
    //MARK: - willAppear
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "My Desk"
        uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        if uid != nil{
            
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
            downloadCosmeticList(orderBy: "recent")
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList(orderBy: "recent")
        }
        downloadBeautySet(orderBy: "recent")
        welcomeNameLabel.text = UserDefaults.standard.string(forKey: ConstantUser.nickName)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let nologinVc = (self.storyboard?.instantiateViewController(identifier: "nologin")) as! NoLoginViewController
        let viewControllers: [UIViewController] = self.children
        if uid != nil{
            downloadDesk()
            
            for vcs in viewControllers{
                vcs.willMove(toParent: nil)
                vcs.view.removeFromSuperview()
                vcs.removeFromParent()
            }
        }else{
            add(nologinVc)
        }
        
        sortCollection.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    //MARK: - Go to another viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = deskCollection.indexPathsForSelectedItems?.first
            let item = deskList[itemIndex!.row]
            destination?.delegate = self
            destination?.productId = Int(item.product_id!)
            
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
    
    private func downloadCosmeticList(orderBy: String){
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getCosmeticDeskByUserid(orderby: orderBy)
    }
    
    private func downloadFavoriteList(orderBy: String){
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getFavorite(orderBy: orderBy)
    }
    
    private func downloadBeautySet(orderBy: String){
        let downloadSaveTopic = DownloadSaveTopic()
        downloadSaveTopic.delegate = self
        downloadSaveTopic.downloadSaveTopic(orderBy: orderBy)
    }
    
    private func refreshData(){
        let index = sortCollection.indexPathsForSelectedItems?.first
        var order: String = ""
        
        if menuSegment.selectedSegmentIndex == 0 || menuSegment.selectedSegmentIndex == 1{
            switch index!.row {
            case 0: order = "recent"
            case 1: order = "a-z"
            case 2: order = "view"
            case 3: order = "price"
            default: downloadCosmeticList(orderBy: "recent")
            }
        }else if menuSegment.selectedSegmentIndex == 2{
            switch index!.row {
            case 0: order = "recent"
            case 1: order = "a-z"
            case 2: order = "view"
            default: downloadCosmeticList(orderBy: "recent")
            }
        }
        
        if menuSegment.selectedSegmentIndex == 0{
            downloadCosmeticList(orderBy: order)
        }else if menuSegment.selectedSegmentIndex == 1{
            downloadFavoriteList(orderBy: order)
        }else if menuSegment.selectedSegmentIndex == 2{
            downloadBeautySet(orderBy: order)
        }
        deskCollection.reloadData()
    }
    
    private func noItemupdate(segment: Int){
        switch segment {
        case 0:
            noItemIcon.image = UIImage.init(systemName: "bag.fill")
            noItemLabel.text = "No item in your desk"
            noItemDetail.text = "Explore cosmetic items and save them to your desk."
        case 1:
            noItemIcon.image = UIImage.init(systemName: "heart.fill")
            noItemLabel.text = "No favorite item in your desk"
            noItemDetail.text = "Tap heart to mark most item you love."
        case 2:
            noItemIcon.image = UIImage.init(systemName: "square.grid.2x2.fill")
            noItemLabel.text = "No beauty set in your desk"
            noItemDetail.text = "Explore beauty set and save them to your desk"
        default:
            noItemLabel.text = "No item in your desk"
            noItemDetail.text = "Explore cosmetic items and save them to your desk."
        }
    }

}

extension CosmeticDeskViewController: DownloadCosmeticDeskListDelegate, DeskCollectionViewCellDelegate, CosmeticDeskDelegate, CosmeticDetailDelegate, DownloadSaveTopicDelegate{
    func checkedItem(isSave: Bool) {
        
    }
    
    func downloadSaveTopicSuccess(item: NSMutableArray) {
        saveTopic = item as! [TopicModel]
        let formatNum = Library.countNumFormat(num: saveTopic.count)
        countTopic.text = "\(formatNum)"
        if menuSegment.selectedSegmentIndex == 2{
            if saveTopic.count > 0{
                noItemview.visibility = .gone
                deskCollection.visibility = .visible
            }else{
                noItemview.visibility = .visible
                deskCollection.visibility = .gone
                noItemupdate(segment: 2)
            }
            deskCollection.reloadData()
            removeSpinner()
            deskRefreshControl.endRefreshing()
        }
    }
    
    func downloadSaveTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    //MARK: - Tap Action from cosmetic desk item
    func tapAction(productId: Int, image: UIImage, indexPath: IndexPath, button: UIButton) {
        let item = deskList[indexPath.row]
        
        let deskItemAction = UIAlertController(title: item.product_name, message: "Do you want to do next?", preferredStyle: .actionSheet)
        deskItemAction.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            
            let productId: Int = item.product_id!
            //let getAddress = webAddress()
            let url = URL(string: "http://54.255.220.88/?cosmeticid=\(productId)")
            
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
            cosmeticDesk.deleteFromDesk(productId: productId)
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
            noItemview.visibility = .gone
            deskCollection.visibility = .visible
        }else{
            noItemview.visibility = .visible
            deskCollection.visibility = .gone
            if menuSegment.selectedSegmentIndex == 0{
                noItemupdate(segment: 0)
            }else{
                noItemupdate(segment: 1)
            }
        }
        
        if menuSegment.selectedSegmentIndex == 0{
            let formatNum = Library.countNumFormat(num: deskList.count)
            countLabel.text = "\(formatNum)"
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
    
    func onSuccess(isSave: Bool) {
        refreshData()
    }
    
    func onFailed() {
        
    }
}

extension CosmeticDeskViewController: BeautySetCollectionViewCellDelegate, SaveTopicDelegate{
    func saveTopicSuccess() {
        removeSpinner()
        downloadBeautySet(orderBy: "recent")
        deskCollection.reloadData()
    }
    
    func saveTopicFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Failed to delete")
    }
    
    func tapBeautysetOption(indexPath: IndexPath, button: UIButton) {
        let item = saveTopic[indexPath.row]
        let setOption = UIAlertController(title: item.topic_name, message: "What do you next?", preferredStyle: .actionSheet)
        setOption.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            let topicId: Int = item.topic_id!
            //let getAddress = webAddress()
            let url = URL(string: "http://54.255.220.88/?topicId=\(topicId)")
            
            let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
            
            //For iPad
            if let popoverController = activityViewController.popoverPresentationController{
                popoverController.sourceView = button
                popoverController.sourceRect = button.bounds
            }
            
            self.present(activityViewController, animated: true, completion: nil)
        }))
        
        setOption.addAction(UIAlertAction(title: "Delete from save set", style: .destructive, handler: {
            (UIAlertAction) in
            self.showSpinner(onView: self.view)
            let saveTopic = SaveTopic()
            saveTopic.delegate = self
            saveTopic.deleteTopic(topicId: item.topic_id!)
        }))
        
        setOption.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (UIAlertAction) in
        }))
        
        if let popoverController = setOption.popoverPresentationController{
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        self.present(setOption, animated: true, completion: nil)
    }
    
}
