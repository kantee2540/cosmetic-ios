//
//  ShareBeautysetViewController.swift
//  Cosmetic
//
//  Created by Omp on 6/12/2563 BE.
//  Copyright © 2563 BE Omp. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

protocol ShareBeautysetDelegate {
    func finishedCreateset()
}

class ShareBeautysetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate ,ChooseProductDelegate, AddTopicDelegate, DownloadTopicProtocol, EditTopicDeletegate{
    
    @IBOutlet weak var selectedTableview: UITableView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var titleTextfield: CustomTextfield!
    @IBOutlet weak var descTextview: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectedTableviewHeight: NSLayoutConstraint!
    private var selectedProduct: [CosmeticDeskModel] = []
    private var addProduct: [CosmeticDeskModel] = []
    private var deleteProduct: [CosmeticDeskModel] = []
    private var isEditmode: Bool = false
    var delegate: ShareBeautysetDelegate?
    var topicId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if topicId != nil{
            editingMode()
        }
        
        selectedTableview.delegate = self
        selectedTableview.dataSource = self
        selectedTableview.isEditing = true
        titleTextfield.delegate = self
        setupView()
    }
    
    func editingMode(){
        selectedProduct = []
        addProduct = []
        deleteProduct = []
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.downloadOneItem(topicId: topicId!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseproduct"{
            let destination = segue.destination as! ChooseProductTopicTableViewController
            destination.delegate = self
        }
    }
    
    private func setupView(){
        titleTextfield.layer.cornerRadius = 10
        descTextview.layer.cornerRadius = 10
        selectImageButton.makeRoundedView()
        selectButton.makeRoundedView()
        
    }
    @IBAction func tapShare(_ sender: Any) {
        showSpinner(onView: self.view)
        if isEditmode{
            var productIdAdd: [Any] = []
            var productIdDelete :[Any] = []
            for i in addProduct{
                productIdAdd.append(i.product_id!)
            }
            for j in deleteProduct{
                productIdDelete.append(j.product_id!)
            }
            let editTopic = Topic()
            editTopic.editDelegate = self
            editTopic.editTopic(topicId: topicId, topic_name: titleTextfield.text ?? "", topic_desc: descTextview.text ?? "", new_set: productIdAdd, delete_set: productIdDelete, image: coverImage.image)
            
        }else{
            var productIdSet :[Any] = []
            for i in selectedProduct{
                productIdSet.append(i.product_id!)
            }
            let addTopic = Topic()
            addTopic.delegate = self
            addTopic.insertTopic(topic_name: titleTextfield.text ?? "", topic_desc: descTextview.text ?? "", productSet: productIdSet, image: coverImage.image)
        }
    }
    
    func insertTopicSuccess(topicCode: String) {
        removeSpinner()
        
        dismiss(animated: true, completion: {()in
            self.delegate?.finishedCreateset()
        })
    }
    
    func editTopicSuccess() {
        removeSpinner()
        dismiss(animated: true, completion: {()in
            self.delegate?.finishedCreateset()
        })
    }
    
    func editTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Edit beauty set failed", message: error)
    }
    
    func insertTopicFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Add beauty set failed", message: error)
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSelectImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        
        let action = UIAlertController(title: "Select Image", message: "", preferredStyle: .actionSheet)
        action.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (UIAlertAction) in
            pickerController.sourceType = .camera
            self.navigationController?.present(pickerController, animated: true, completion: nil)
        }))
        action.addAction(UIAlertAction(title: "Library", style: .default, handler: {
            (UIAlertAction) in
            pickerController.sourceType = .photoLibrary
            self.navigationController?.present(pickerController, animated: true, completion: nil)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (UIAlertAction) in
        }))
        
        if let popoverController = action.popoverPresentationController{
            popoverController.sourceView = selectButton
            popoverController.sourceRect = selectButton.bounds
        }
        
        self.present(action, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        coverImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicitem") as! TopTopicItemTableViewCell
        let item = selectedProduct[indexPath.row]
        cell.itemProduct.text = item.product_name
        cell.itemDescription.text = item.product_description
        if item.product_img != ""{
            cell.itemImage.downloadImage(from: URL(string: item.product_img!)!)
        }
        return cell
    }
    
    func finshedSelectItem(item: [CosmeticDeskModel]) {
        
        selectedProduct.append(contentsOf: item)
        if isEditmode{
            addProduct.append(contentsOf: item)
        }
        selectedTableview.reloadData()
        showSpinner(onView: self.view)
        removeSpinner()
    }
    
    func topicDownloaded(item: NSMutableArray) {
        
    }
    
    func topicGetItem(detail: TopicModel, packages: NSMutableArray) {
        self.navigationItem.title = "Edit beauty set"
        titleTextfield.text = detail.topic_name
        descTextview.text = detail.topic_description
        coverImage.downloadImage(from: URL(string: detail.topic_img!)!)
        
        shareButton.isEnabled = true
        shareButton.title = "Save"
        
        for i in packages as! [PackageModel]{
            let packageDesk = CosmeticDeskModel()
            packageDesk.product_id = i.product_id
            packageDesk.product_name = i.product_name
            packageDesk.product_price = i.product_price
            packageDesk.categories_name = i.categories_name
            packageDesk.product_img = i.product_img
            selectedProduct.append(packageDesk)
        }
        
        isEditmode = true
        selectedTableview.reloadData()
    }
    
    func topicError(error: String) {
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.selectedTableviewHeight.constant = self.selectedTableview.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewDidLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if isEditmode{
                if !addProduct.contains(selectedProduct[indexPath.row]){
                    deleteProduct.append(selectedProduct[indexPath.row])
                }
            }
            selectedProduct.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0{
            shareButton.isEnabled = true
        }else{
            shareButton.isEnabled = false
        }
    }
}
