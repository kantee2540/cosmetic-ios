//
//  CosmeticInfoViewController.swift
//  Cosmetic
//
//  Created by Omp on 6/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class CosmeticInfoViewController: UIViewController {
    
    var product_name: String!
    var product_description: String!
    var product_price: String!
    var categories_name: String?
    var categories_type: String?
    var brand_name: String?
    var product_img: String?
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var categoriesText: UILabel!
    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let share_image = UIImage(named: "shareIcon")
        let sharebtn = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(getShare(_:)))
        sharebtn.image = share_image
        self.navigationItem.rightBarButtonItem = sharebtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = brand_name
        nameText?.text = product_name
        descriptionText?.text = product_description
        priceText?.text = product_price
        categoriesText?.text = categories_name
        
        downloadImage(urlImage: product_img!)
    }
    
    @objc func getShare(_: UIBarButtonItem){
        
        let textShare = product_name
        
        let textToShare =  [ textShare ]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    func downloadImage(urlImage :String){
        let session = URLSession(configuration: .default)
        let url = URL(string: urlImage)
        
        let getImageFromUrl = session.dataTask(with: url!) { data, responds, error in
            if let e = error{
                print("Error = \(e)")
            }
            else {
                if (responds as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        
                        DispatchQueue.main.async {
                            let imageFromServer = UIImage(data: imageData)
                            self.coverImage.image = imageFromServer
                        }
                        
                        
                    }
                    else{
                        print("Image file is currupted")
                    }
                }
                else{
                    print("No response from server")
                }
            }
        }
        
        getImageFromUrl.resume()
        
    }

}
