//
//  CosmeticDeskViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CosmeticDeskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var deskView: UIView!
    @IBOutlet weak var noCosmetic: UILabel!
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var allNumber: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var deskCollection: UICollectionView!
    @IBOutlet weak var menuSegment: UISegmentedControl!
    
    private var deskList: [CosmeticDeskModel] = []
    private var drawerList: [DrawerModel] = []
    private var userId: String?
    private var spinnerIsShow: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if menuSegment.selectedSegmentIndex == 1{
            return drawerList.count + 1
        }else{
            return deskList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if menuSegment.selectedSegmentIndex == 1{
            if indexPath.row < drawerList.count{
                let drawerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "draweritem", for: indexPath) as! DrawerCollectionViewCell
                let item = drawerList[indexPath.row]
                drawerCell.drawerNameLabel.text = item.drawer_name
                drawerCell.layer.cornerRadius = 8
                
                return drawerCell
            }
            else{
                let drawerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "adddrawercell", for: indexPath)
                drawerCell.layer.cornerRadius = 8
                return drawerCell
            }
            
        }
        else{
            let deskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartitem", for: indexPath) as! DeskCollectionViewCell
            let item = deskList[indexPath.row]
            deskCell.delegate = self
            deskCell.productId = item.product_id
            deskCell.userId = userId
            deskCell.indexPath = indexPath
            
            deskCell.productName.text = item.product_name
            deskCell.productImage.downloadImage(from: URL(string: item.product_img!)!)
            deskCell.brand.text = item.brand_name?.uppercased()
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price!))
            deskCell.productPrice.text = "฿" + formattedPrice!
            deskCell.layer.cornerRadius = 8
            
            return deskCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath) {
        let item = deskList[indexPath.row]
        
        let deskItemAction = UIAlertController(title: item.product_name, message: "Do you want to do next?", preferredStyle: .actionSheet)
        deskItemAction.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            //Tap share
            let titleActivity: String = item.product_name!
            let description: String = item.product_description!
            let image = image
            let activityViewController = UIActivityViewController(activityItems: [titleActivity, description, image], applicationActivities: nil)
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
        deskItemAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
        self.present(deskItemAction, animated: true, completion: nil)
    }
    
    
    @IBAction func changeMenuSegment(_ sender: Any) {
        showSpinner(onView: self.view)
        if menuSegment.selectedSegmentIndex == 0{
            downloadCosmeticList()
        }else if menuSegment.selectedSegmentIndex == 1{
            noCosmetic.text = ""
            noCosmetic.isHidden = true
            downloadDrawerList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.updateViewConstraints()
        self.collectionHeight.constant = deskCollection.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        if userId != nil{
            showSpinner(onView: self.view)
            spinnerIsShow = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Cosmetic Desk"
        
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        
        if userId != nil{
            if menuSegment.selectedSegmentIndex == 0{
                downloadCosmeticList()
            }else if menuSegment.selectedSegmentIndex == 1{
                downloadDrawerList()
            }
            welcomeNameLabel.text = "Hi, " + UserDefaults.standard.string(forKey: ConstantUser.nickName)!
        }else{
            deskList.removeAll()
            deskCollection.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        allNumber.layer.masksToBounds = false
        allNumber.layer.cornerRadius = allNumber.frame.height / 2
        allNumber.clipsToBounds = true
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = deskCollection.indexPathsForSelectedItems?.first
            let item = deskList[itemIndex!.row]
            destination?.delegate = self
            destination?.productId = item.product_id
            
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
    
    private func downloadDrawerList(){
        let downloadDrawer = DownloadDrawer()
        downloadDrawer.delegate = self
        downloadDrawer.downloadDrawer(userid: userId!)
    }

}

extension CosmeticDeskViewController: DownloadDrawerDelegate, DownloadCosmeticDeskListDelegate, DeskCollectionViewCellDelegate, CosmeticDeskDelegate, CosmeticDetailDelegate{
    
    func itemDrawerDownloaded(item: NSMutableArray) {
        drawerList = item as! [DrawerModel]
        deskCollection.reloadData()
        removeSpinner()
    }
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        deskList = item as! [CosmeticDeskModel]
        allNumber.text = String(deskList.count)
        if deskList.count > 0{
            noCosmetic.text = ""
            noCosmetic.isHidden = true
        }else{
            noCosmetic.text = "No cosmetic in your desk"
            noCosmetic.isHidden = false
        }
        deskCollection.reloadData()
        removeSpinner()
        
    }
    
    func onSuccess() {
        downloadCosmeticList()
    }
    
    func onFailed() {
        
    }
}
