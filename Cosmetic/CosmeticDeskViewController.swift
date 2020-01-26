//
//  CosmeticDeskViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CosmeticDeskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DownloadCosmeticDeskListDelegate, DeskCollectionViewCellDelegate, CosmeticDeskDelegate, CosmeticDetailDelegate {
    
    @IBOutlet var deskView: UIView!
    @IBOutlet weak var noCosmetic: UILabel!
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var allNumber: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var deskCollection: UICollectionView!
    private var deskList: [CosmeticDeskModel] = []
    private var userId: String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func onSuccess() {
        downloadCosmeticList()
    }
    
    func onFailed() {
        
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
    
    override func viewWillLayoutSubviews() {
        self.updateViewConstraints()
        self.collectionHeight.constant = deskCollection.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Cosmetic Desk"
        allNumber.layer.masksToBounds = false
        allNumber.layer.cornerRadius = allNumber.frame.height / 2
        allNumber.clipsToBounds = true
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        
        if userId != nil{
            showSpinner(onView: self.view)
            downloadCosmeticList()
            welcomeNameLabel.text = "Hi, " + UserDefaults.standard.string(forKey: ConstantUser.nickName)!
        }else{
            deskList.removeAll()
            deskCollection.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        deskCollection.delegate = self
        deskCollection.dataSource = self
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getCosmeticDeskByUserid(userId: userId!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
