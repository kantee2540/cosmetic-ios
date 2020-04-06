//
//  DrawerCollectionViewController.swift
//  Cosmetic
//
//  Created by Omp on 5/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class DrawerCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DownloadDrawerCollectionDelegate, DeskCollectionViewCellDelegate, DrawerCollectionDelegate, CosmeticDeskDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var contentScrollview: UIScrollView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var drawerNameLabel: UILabel!
    @IBOutlet weak var countCollectionLabel: UILabel!
    @IBOutlet weak var drawerCollection: UICollectionView!
    
    private var drawerCollectionList: [DrawerCollectionModel] = []
    
    var drawerId :String?
    var drawerName: String?
    var userId: String?
    
    func onSuccess() {
        downloadDrawerCollection()
    }
    
    func onFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Delete item failed!")
    }
    
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath) {
        let item = drawerCollectionList[indexPath.row]
                
        let deskItemAction = UIAlertController(title: item.product_name, message: "Do you want to do next?", preferredStyle: .actionSheet)
        deskItemAction.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            //Tap share
            let productId: String = item.product_id!
            let getAddress = webAddress()
            let url = URL(string: getAddress.getrootURL() + "?cosmeticid=\(productId)")
            
            let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            
        }))
        deskItemAction.addAction(UIAlertAction(title: "Delete from this drawer", style: .default, handler: {(UIAlertAction) in
            let drawerCollection = DrawerCollection()
            drawerCollection.delegate = self
            drawerCollection.deleteFromCollection(collection_id: item.drawer_collection_id!)
        
            }))
        
        deskItemAction.addAction(UIAlertAction(title: "Delete from my desk", style: .destructive, handler: {
            (UIAlertAction) in
            //Delete this product item
            let cosmeticDesk = CosmeticDesk()
            cosmeticDesk.delegate = self
            cosmeticDesk.deleteFromDesk(productId: productId, userId: userId)
        }))
        deskItemAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in }))
        self.present(deskItemAction, animated: true, completion: nil)
    }
    
    
    func itemDrawerCollectionSuccess(item: NSMutableArray) {
        removeSpinner()
        drawerCollectionList = item as! [DrawerCollectionModel]
        countCollectionLabel.text = "\(drawerCollectionList.count) Cosmetics in drawer"
        
        let noItemVC = self.storyboard?.instantiateViewController(identifier: "noitemcollection") as! NoItemInDrawerViewController
        let viewController: [UIViewController] = self.children
        if drawerCollectionList.count > 0{
            self.navigationItem.title = nil
            for vcs in viewController{
                vcs.willMove(toParent: nil)
                vcs.view.removeFromSuperview()
                vcs.removeFromParent()
            }
        }else{
            self.navigationItem.title = drawerName
            add(noItemVC)
        }
        drawerCollection.reloadData()
    }
    
    func itemDrawerCollectionFailed(error: String) {
        
    }
    
    override func viewDidLayoutSubviews() {
        self.updateViewConstraints()
        self.collectionHeight.constant = drawerCollection.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drawerCollectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionitem", for: indexPath) as? DeskCollectionViewCell
        let item = drawerCollectionList[indexPath.row]
        cell?.delegate = self
        
        cell?.productId = item.product_id
        cell?.userId = userId
        cell?.indexPath = indexPath
        
        cell?.brand.text = item.brand_name
        cell?.productName.text = item.product_name
        if item.product_img != ""{
            cell?.productImage.downloadImage(from: URL(string: item.product_img!)!)
        }
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price!))
        cell?.productPrice.text = "฿" + formattedPrice!
        cell?.layer.cornerRadius = 8
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 68{
            self.navigationItem.title = drawerName
        }else{
            self.navigationItem.title = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawerCollection.delegate = self
        drawerCollection.dataSource = self
        contentScrollview.delegate = self
        
        drawerNameLabel.text = drawerName
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadDrawerCollection()
    }
    
    private func downloadDrawerCollection(){
        showSpinner(onView: self.view)
        let downloadDrawerCollection = DownloadDrawerCollection()
        downloadDrawerCollection.delegate = self
        downloadDrawerCollection.downloadDrawerCollection(userId: userId!, drawerId: drawerId!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = drawerCollection.indexPathsForSelectedItems?.first
            let item = drawerCollectionList[itemIndex!.row]
            destination?.productId = item.product_id
        }else if segue.identifier == "addproduct"{
            let destination = segue.destination as? AddProductDrawerTableViewController
            destination?.drawerId = drawerId
        }
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
