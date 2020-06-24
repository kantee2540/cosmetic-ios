//
//  CosmeticDetailViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
protocol CosmeticDetailDelegate {
    func dismissFromCosmeticDetail()
}

class CosmeticDetailViewController: UIViewController, DownloadProductProtocol, CosmeticDeskDelegate, DownloadCosmeticDeskListDelegate{
    
    var delegate: CosmeticDetailDelegate?
    var productId: String!
    private var productData: [ProductModel] = []
    private var isSave: Bool = false
    
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        if item.count > 0{
            isSave = true
            disableSaveButton()
        }
    }
    
    func itemCosmeticDeskFailed(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func itemDownloaded(item: NSMutableArray) {
        if item.count > 0{
            productData = item as! [ProductModel]
            brandName.text = productData[0].brand_name?.uppercased()
            productNameLabel.text = productData[0].product_name
            productDescriptionLabel.text = productData[0].product_description
            productImage.downloadImage(from: URL(string: productData[0].product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
            priceLabel.text = formattedPrice! + " Baht"
            
            categoryLabel.text = productData[0].categories_name
            categoryTypeLabel.text = productData[0].categories_type
            
        }else{
            let alert = UIAlertController(title: "No Product", message: "Sorry, Product you're looking not found.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.removeSpinner()
    }
    
    func itemDownloadFailed(error_mes: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Something went wrong\n\(error_mes)")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProduct()
        priceView.makeRoundedView()
        categoryView.makeRoundedView()
        saveButton.roundedCorner()
    }
    
    private func setProduct(){
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadSelectItem(productId: productId)
        
        if UserDefaults.standard.string(forKey: ConstantUser.userId) != nil{
            let downloadDesk = DownloadCosmeticDeskList()
            downloadDesk.delegate = self
            downloadDesk.checkCosmeticIsSaved(userId: UserDefaults.standard.string(forKey: ConstantUser.userId)!, productId: productId)
        }
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapShare(_ sender: Any) {
        
//        let titleActivity: String = productData[0].product_name!
//        let description: String = productData[0].product_description!
//        let image: UIImage = productImage.image!
        let productId: String = productData[0].product_id!
        let getAddress = webAddress()
        let url = URL(string: getAddress.getrootURL() + "?cosmeticid=\(productId)")
        
        let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func tapSave(_ sender: Any) {
        if UserDefaults.standard.string(forKey: ConstantUser.userId) != nil{
            if !isSave{
                let insertItem = CosmeticDesk()
                insertItem.delegate = self
                insertItem.insertToDesk(productId: productId, userId: UserDefaults.standard.string(forKey: ConstantUser.userId)!)
            }else{
                let insertItem = CosmeticDesk()
                insertItem.delegate = self
                insertItem.deleteFromDesk(productId: productId, userId: UserDefaults.standard.string(forKey: ConstantUser.userId)!)
            }
        }else{
            dismiss(animated: true, completion: nil)
            self.delegate?.dismissFromCosmeticDetail()
        }
    }
    
    func onSuccess() {
        if !isSave{
            disableSaveButton()
            isSave = true
        }else{
            enableSaveButton()
            isSave = false
        }
    }
    
    func onFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Save cosmetic to desk fail please try again.")
    }

    private func disableSaveButton(){
        saveButton.tintColor = UIColor.systemYellow
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
    private func enableSaveButton(){
        saveButton.tintColor = UIColor.label
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}
