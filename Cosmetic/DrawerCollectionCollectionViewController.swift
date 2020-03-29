//
//  DrawerCollectionCollectionViewController.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionitem"

class DrawerCollectionCollectionViewController: UICollectionViewController, DownloadDrawerCollectionDelegate, DeskCollectionViewCellDelegate, CosmeticDeskDelegate, DrawerCollectionDelegate {
    
    func onSuccess() {
        downloadCollectionList()
    }
    
    func onFailed() {
        
    }
    
    func tapAction(userId: String, productId: String, image: UIImage, indexPath: IndexPath) {
        let item = drawerCollectionList[indexPath.row]
        
        let deskItemAction = UIAlertController(title: item.product_name, message: "Do you want to do next?", preferredStyle: .actionSheet)
        deskItemAction.addAction(UIAlertAction(title: "Share", style: .default, handler: {
            (UIAlertAction) in
            //Tap share
//            let titleActivity: String = item.product_name!
//            let description: String = item.product_description!
//            let image = image
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
        collectionView.reloadData()
        
        let noItemVC = self.storyboard?.instantiateViewController(identifier: "noitemcollection") as! NoItemInDrawerViewController
        let viewController: [UIViewController] = self.children
        if drawerCollectionList.count > 0{
            for vcs in viewController{
                vcs.willMove(toParent: nil)
                vcs.view.removeFromSuperview()
                vcs.removeFromParent()
            }
        }else{
            add(noItemVC)
        }
        
    }
    
    func itemDrawerCollectionFailed(error: String){
        Library.displayAlert(targetVC: self, title: "Error", message: error)
        removeSpinner()
    }
    
    var drawerId :String?
    var drawerName: String?
    var userId: String?
    
    private var drawerCollectionList: [DrawerCollectionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = drawerName
        
        // Register cell classes
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadCollectionList()
    }
    
    private func downloadCollectionList(){
        showSpinner(onView: self.view)
        let drawerCollection = DownloadDrawerCollection()
        drawerCollection.delegate = self
        drawerCollection.downloadDrawerCollection(userId: userId!, drawerId: drawerId!)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return drawerCollectionList.count
    }

    //MARK: - Featch item to cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DeskCollectionViewCell
        let item = drawerCollectionList[indexPath.row]
        cell.delegate = self
        
        cell.productId = item.product_id
        cell.userId = userId
        cell.indexPath = indexPath
        
        // Configure the cell
        cell.productName.text = item.product_name
        cell.brand.text = item.brand_name
        if item.product_img != nil{
            cell.productImage.downloadImage(from: URL(string: item.product_img!)!)
        }
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value: item.product_price!))
        cell.productPrice.text = "฿" + formattedPrice!
        cell.layer.cornerRadius = 8
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = collectionView.indexPathsForSelectedItems?.first
            let item = drawerCollectionList[itemIndex!.row]
            destination?.productId = item.product_id
        }else if segue.identifier == "addproduct"{
            let destination = segue.destination as? AddProductDrawerTableViewController
            destination?.drawerId = drawerId
        }
    }

}
