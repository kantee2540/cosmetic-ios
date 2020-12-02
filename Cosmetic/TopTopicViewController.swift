//
//  TopTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 29/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

protocol TopTopicDelegate {
    func dismissFromTopTopic()
}

class TopTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CosmeticDetailDelegate, DownloadTopicProtocol, SaveTopicDelegate, DownloadSaveTopicDelegate {
    func topicGetItem(detail: TopicModel, packages: NSMutableArray) {
        titleLabel.text = detail.topic_name
        descriptionLabel.text = detail.topic_description
        personLabel.text = detail.nickname
        coverImage.downloadImage(from: URL(string: detail.topic_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
        topicItem = packages as! [PackageModel]
        likeCountLabel.text = Library.countNumFormat(num: detail.likeCount ?? 0)
        productTable.reloadData()
        removeSpinner()
    }
    
    func downloadSaveTopicSuccess(item: NSMutableArray) {
        if item.count > 0{
            isSavedTopic = true
            savedButtonState()
        }else{
            isSavedTopic = false
            unsavedButtonState()
        }
    }
    
    func downloadSaveTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    func saveTopicSuccess() {
        if !isSavedTopic{
            isSavedTopic = true
            savedButtonState()
        }else{
            isSavedTopic = false
            unsavedButtonState()
        }
    }
    
    private func savedButtonState(){
        saveLabel.text = "Saved"
        saveButton.tintColor = UIColor.systemYellow
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        
    }
    
    private func unsavedButtonState(){
        saveLabel.text = "Save"
        saveButton.tintColor = UIColor.label
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
    }
    
    func saveTopicFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Save Topic Failed!")
    }
    
    func topicDownloaded(item: NSMutableArray) {
        if item.count > 0{
            topicHeadItem = item as! [TopicModel]
            let item = topicHeadItem[0]
            titleLabel.text = item.topic_name
            descriptionLabel.text = item.topic_description
            personLabel.text = item.nickname
            
            if item.topic_img != ""{
                coverImage.downloadImage(from: URL(string: item.topic_img ?? "") ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
            }else{
                coverImage.image = UIImage.init(named: "bg4")
            }
        }else{
            let alert = UIAlertController(title: "Topic Not found", message: "This topic has been removed or not avaliable.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func topicError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissFromCosmeticDetail() {
        dismiss(animated: true, completion: nil)
        self.delegate?.dismissFromTopTopic()
    }
    
    func itemDownloaded(item: NSMutableArray) {
        topicItem = item as! [PackageModel]
        settingtitleLabel()
        
        removeSpinner()
        productTable.reloadData()
    }
    
    var delegate: TopTopicDelegate?
    var topicId: Int?
    private var topicHeadItem: [TopicModel] = []
    private var topicItem: [PackageModel] = []
    private var isSavedTopic: Bool = false
    private var userId: Int?
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var dislikeCountLabel: UILabel!
    @IBOutlet weak var productTableHeight: NSLayoutConstraint!
    @IBOutlet weak var topicScroll: UIScrollView!
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.productTableHeight.constant = self.productTable.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 220{
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
        
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.getTopicById(topicId: topicId!)
        
        userId = UserDefaults.standard.integer(forKey: ConstantUser.userId)
        if userId != nil{
//            checkSaveTopic()
//            checkLike()
        }
        
//        downloadPackage()
//        getLikeCount()
    }
    
    private func settingtitleLabel(){
        shareButton.roundedCorner()
        saveButton.roundedCorner()
        
        
    }
    @IBAction func tapSave(_ sender: Any) {
        
        if userId != nil{
            let saveTopic = SaveTopic()
            saveTopic.delegate = self
            if !isSavedTopic{
                //To save
                saveTopic.saveTopic(topicId: topicId!, userId: userId!)
                let snackMessage = MDCSnackbarMessage()
                snackMessage.text = "Saved cosmetic set to desk"
                MDCSnackbarManager().show(snackMessage)
            }else{
                //To remove
                saveTopic.deleteTopic(topicId: topicId!, userId: userId!)
                let snackMessage = MDCSnackbarMessage()
                snackMessage.text = "Removed cosmetic set from desk"
                MDCSnackbarManager().show(snackMessage)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
            delegate?.dismissFromTopTopic()
        }
    }
    
    @IBAction func tapLike(_ sender: Any) {
        if userId != nil{
            
        }else{
            self.dismiss(animated: true, completion: nil)
            delegate?.dismissFromTopTopic()
        }
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tapShare(_ sender: Any) {
//        let titleActivity: String = topicHeadItem[0].topic_name!
//        let description: String = topicHeadItem[0].topic_description!
//        let image: UIImage = coverImage.image!
        
        let getAddress = webAddress()
        let url = URL(string: getAddress.getrootURL() + "\(topicId ?? 0)")
        
        let activityViewController = UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
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

extension TopTopicViewController: LikeDislikeDelegate, SetLikeUnlikeDelegate{
    
    func setLike(){
        let setLikeUnlike = SetLikeUnlike()
        setLikeUnlike.delegate = self
        setLikeUnlike.like(userId: userId!, topicId: topicId!)
    }
    
    func checkLike(){
        let setLikeUnlike = SetLikeUnlike()
        setLikeUnlike.delegate = self
        setLikeUnlike.checkLike(userId: userId!, topicId: topicId!)
    }
    
    func setLikeUnlikeSuccess(like: Bool) {
        if like{
            likeButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            likeButton.tintColor = UIColor.systemGreen
            
        }else{
            likeButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            likeButton.tintColor = UIColor.label
            
        }
        
        getLikeCount()
    }
    
    func setLikeUnlikeFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: "Can't like please try again")
    }
    
    
    func getLikeCount(){
        let likeDislike = CountLike()
        likeDislike.delegate = self
        likeDislike.getLikeCount(topicId: topicId!)
    }
    
    func getLikeDislikeSuccess(like: Int) {
        let likeCount = Library.countNumFormat(num: like)
        likeCountLabel.text = likeCount
    }
    
    func getLikeDislikeFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    
}
