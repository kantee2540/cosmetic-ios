//
//  CosmeticDeskViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CosmeticDeskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DownloadCosmeticDeskListDelegate {
    
    @IBOutlet weak var noCosmetic: UILabel!
    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var allNumber: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var deskCollection: UICollectionView!
    private var deskList: [CosmeticDeskModel] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let deskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartitem", for: indexPath) as! DeskCollectionViewCell
        let item = deskList[indexPath.row]
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
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        deskList = item as! [CosmeticDeskModel]
        allNumber.text = String(deskList.count)
        if deskList.count > 0{
            noCosmetic.text = ""
            noCosmetic.isHidden = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        deskCollection.delegate = self
        deskCollection.dataSource = self
        let downloadDeskCosmetic = DownloadCosmeticDeskList()
        downloadDeskCosmetic.delegate = self
        downloadDeskCosmetic.getCosmeticDeskByUserid(userId: UserDefaults.standard.string(forKey: ConstantUser.userId)!)
        welcomeNameLabel.text = "Hi, " + UserDefaults.standard.string(forKey: ConstantUser.nickName)!
        allNumber.layer.masksToBounds = false
        allNumber.layer.cornerRadius = allNumber.frame.height / 2
        allNumber.clipsToBounds = true
        // Do any additional setup after loading the view.
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
