//
//  TopTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 29/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

protocol TopTopicDelegate {
    func dismissFromTopTopic()
}

class TopTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadPackageProtocol, CosmeticDetailDelegate {
    func dismissFromCosmeticDetail() {
        dismiss(animated: true, completion: nil)
        self.delegate?.dismissFromTopTopic()
    }
    
    func itemDownloaded(item: NSMutableArray) {
        topicItem = item as! [PackageModel]
        settingtitleLabel()
        if topicImg != ""{
            coverImage.downloadImage(from: URL(string: topicImg ?? "") ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
        }else{
            coverImage.image = UIImage.init(named: "bg4")
        }
        
        
        removeSpinner()
        productTable.reloadData()
    }
    var delegate: TopTopicDelegate?
    var topicId: String?
    var topicName: String?
    var topicDescription: String?
    var topicImg: String?
    private var topicItem: [PackageModel] = []
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var productTableHeight: NSLayoutConstraint!
    @IBOutlet weak var topicScroll: UIScrollView!
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.productTableHeight.constant = self.productTable.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicItem.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "topicitem") as! TopTopicItemTableViewCell
        let item = topicItem[indexPath.row]
        itemCell.itemProduct.text = item.product_name
        itemCell.itemDescription.text = item.product_description
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
        itemCell.itemPrice.text = "Price: \(formattedPrice ?? "0") Baht"
        itemCell.itemImage.downloadImage(from: URL(string: item.product_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            
        return itemCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 178{
            doneButton.tintColor = UIColor.label
        }else{
            doneButton.tintColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.delegate = self
        productTable.dataSource = self
        showSpinner(onView: self.view)
        topicScroll.delegate = self
        downloadPackage()
    }
    
    private func downloadPackage(){
        let downloadPackage = DownloadPackage()
        downloadPackage.delegate = self
        downloadPackage.downloadByTopicId(id: topicId ?? "")
    }
    
    private func settingtitleLabel(){
        titleLabel.text = topicName
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        titleLabel.layer.shadowRadius = 3
        descriptionLabel.text = topicDescription
        shareButton.roundedCorner()
        saveButton.roundedCorner()
        
        
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapShare(_ sender: Any) {
        let titleActivity: String = topicName!
        let description: String = topicDescription!
        let image: UIImage = coverImage.image!
        let activityViewController = UIActivityViewController(activityItems: [titleActivity, description, image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = productTable.indexPathForSelectedRow?.row
            let item = topicItem[itemIndex!]
            destination?.delegate = self
            destination?.productId = item.product_id
        }
    }
    

}
