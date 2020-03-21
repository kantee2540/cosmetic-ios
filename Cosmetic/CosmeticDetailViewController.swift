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
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var ingredient: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    func itemCosmeticDeskDownloaded(item: NSMutableArray) {
        if item.count > 0{
            disableSaveButton()
        }
    }
    
    func itemCosmeticDeskFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    func itemDownloaded(item: NSMutableArray) {
        productData = item as! [ProductModel]
        brandName.text = productData[0].brand_name?.uppercased()
        productNameLabel.text = productData[0].product_name
        productDescriptionLabel.text = productData[0].product_description
        productImage.downloadImage(from: URL(string: productData[0].product_img!)!)
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
        priceLabel.text = formattedPrice! + " Baht"
        
        categoryLabel.text = productData[0].categories_name
        categoryTypeLabel.text = productData[0].categories_type
        if productData[0].ingredient != "n/a"{
            ingredient.text = productData[0].ingredient
        }else{
            ingredient.text = "Ingredient not available"
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
        let titleActivity: String = productData[0].product_name!
        let description: String = productData[0].product_description!
        let image: UIImage = productImage.image!
        let activityViewController = UIActivityViewController(activityItems: [titleActivity, description, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func tapSave(_ sender: Any) {
        if UserDefaults.standard.string(forKey: ConstantUser.userId) != nil{
            loadingActivity.isHidden = false
            let insertItem = CosmeticDesk()
            insertItem.delegate = self
            insertItem.insertToDesk(productId: productId, userId: UserDefaults.standard.string(forKey: ConstantUser.userId)!)
        }else{
            dismiss(animated: true, completion: nil)
            self.delegate?.dismissFromCosmeticDetail()
        }
    }
    
    func onSuccess() {
        disableSaveButton()
    }
    
    func onFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Save cosmetic to desk fail please try again.")
    }

    private func disableSaveButton(){
        loadingActivity.isHidden = true
        saveButton.backgroundColor = UIColor.gray
        saveButton.setTitle("Saved", for: .disabled)
        saveButton.isEnabled = false
    }
}
