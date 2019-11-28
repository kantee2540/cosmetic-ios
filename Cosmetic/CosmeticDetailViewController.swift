//
//  CosmeticDetailViewController.swift
//  Cosmetic
//
//  Created by Omp on 27/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CosmeticDetailViewController: UIViewController, DownloadProductProtocol {
    
    var productId: String!
    private var productData: [ProductModel] = []
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var price: UILabel!
    
    func itemDownloaded(item: NSMutableArray) {
        productData = item as! [ProductModel]
        showDetail()
        self.removeSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        let downloadProduct = DownloadProduct()
        downloadProduct.delegate = self
        downloadProduct.downloadSelectItem(productId: productId)
    }
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Show Detail after loaded
    func showDetail(){
        productName.text = productData[0].product_name
        productDescription.text = productData[0].product_description
        coverImage.downloadImage(from: URL(string: productData[0].product_img!)!)
        brandName.text = productData[0].brand_name?.uppercased()
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:productData[0].product_price ?? 0))
        price.text = formattedPrice
    }

}
