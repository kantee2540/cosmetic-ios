//
//  WelcomeViewController.swift
//  Cosmetic
//
//  Created by Omp on 26/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, CosmeticDetailDelegate {
    
    func dismissFromCosmeticDetail() {
        let accountVc = storyboard?.instantiateViewController(withIdentifier: "signin")
        self.navigationController?.pushViewController(accountVc!, animated: true)
    }

    @IBOutlet weak var pickYouCollectionView: UICollectionView!
    @IBOutlet weak var startSearchTextfield: UITextField!
    private var pickForYouProduct: [ProductModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let cammerabtn_image = UIImage(named: "cameraicon")
        let cammerabtn = UIBarButtonItem(title: "pp", style: .done, target: self, action: #selector(openCamera(_:)))
        
        //Camera Button
        cammerabtn.image = cammerabtn_image
        tabBarController?.navigationItem.leftBarButtonItem = cammerabtn
        self.hideKeyboardWhenTappedAround()
        
        startSearchTextfield.delegate = self
        startSearchTextfield.layer.cornerRadius = 6
        
        pickYouCollectionView.delegate = self
        pickYouCollectionView.dataSource = self
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadLimitItem(limitNum: 10)
    }
    
    @objc func openCamera(_ :UIBarButtonItem){
        let vc = storyboard?.instantiateViewController(withIdentifier: "cameraViewController")
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Coco"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Seemoredetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = pickYouCollectionView.indexPathsForSelectedItems?.first?.item
            destination?.delegate = self
            let item = pickForYouProduct[itemIndex!]
            destination?.productId = item.product_id
        }
    }

}

extension WelcomeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchDetailView")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, DownloadProductProtocol{
    func itemDownloaded(item: NSMutableArray) {
        pickForYouProduct = item as! [ProductModel]
        pickYouCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickForYouProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pickCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickcell", for: indexPath) as! PickforyouCollectionViewCell
        let item = pickForYouProduct[indexPath.row]
        pickCell.layer.cornerRadius = 5
        pickCell.productName.text = item.product_name
        pickCell.productBrand.text = item.brand_name
        pickCell.productImage.downloadImage(from: URL(string: item.product_img!)!)
        return pickCell
    }
    
    
}
