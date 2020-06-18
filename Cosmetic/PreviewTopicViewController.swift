//
//  PreviewTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 2/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class PreviewTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTopicDelegate {
    func insertTopicSuccess(topicCode: String) {
        let resultVC = storyboard?.instantiateViewController(identifier: "addtopicresult") as? AddTopicResultViewController
        resultVC?.topicCode = topicCode
        self.navigationController?.pushViewController(resultVC!, animated: true)
    }
    
    func insertTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentTableview: UITableView!
    @IBOutlet weak var productTableHeight: NSLayoutConstraint!
    
    var titleTopic: String?
    var descriptionTopic: String?
    var selectedImage: UIImage?
    var isSelectedCustomImage: Bool = false
    var productSet: [ProductModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(onView: self.view)
        contentTableview.delegate = self
        contentTableview.dataSource = self
        contentTableview.reloadData()
        
        titleLabel.text = titleTopic
        descriptionLabel.text = descriptionTopic
        if isSelectedCustomImage{
            topImage.image = selectedImage
        }
        removeSpinner()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapPost(_ sender: Any) {
        showSpinner(onView: self.view)
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId) ?? ""
        let addTopic = AddTopic()
        addTopic.delegate = self
        var productIdSet: [String] = []
        
        for item in productSet{
            productIdSet.append(item.product_id!)
        }
        
        if isSelectedCustomImage{
            addTopic.insertTopic(topic_name: titleTopic!, topic_desc: descriptionTopic!, user_id: userId, productSet: productIdSet, image: selectedImage)
        }else{
            addTopic.insertTopicWithOutImage(topic_name: titleTopic!, topic_desc: descriptionTopic!, user_id: userId, productSet: productIdSet)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "topicitem") as! TopTopicItemTableViewCell
        let item = productSet[indexPath.row]
        itemCell.itemProduct.text = item.product_name
        itemCell.itemDescription.text = item.categories_name
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
        itemCell.itemPrice.text = "\(formattedPrice ?? "0")฿"
        itemCell.itemImage.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.productTableHeight.constant = self.contentTableview.contentSize.height
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
