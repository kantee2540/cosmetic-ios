//
//  TopTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 29/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class TopTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadPackageProtocol {
    func itemDownloaded(item: NSMutableArray) {
        topicItem = item as! [PackageModel]
        mainTable.delegate = self
        mainTable.dataSource = self
        titleLabel.text = topicName
        mainTable.reloadData()
    }
    
    var topicId: String!
    var topicName: String!
    var topicDescription: String!
    private var topicItem: [PackageModel] = []
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return topicItem.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "Content")!
            contentCell.selectionStyle = .none
            contentCell.textLabel?.text = topicDescription
            return contentCell
            
        }
        else{
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "productTopic") as! TopTopicItemTableViewCell
            let item = topicItem[indexPath.row]
            itemCell.itemProduct.text = item.product_name
            itemCell.itemDescription.text = item.product_description
            let numberFormat = NumberFormatter()
            numberFormat.numberStyle = .decimal
            let formattedPrice = numberFormat.string(from: NSNumber(value:item.product_price ?? 0))
            itemCell.itemPrice.text = "Price: \(formattedPrice ?? "0") Baht"
            itemCell.itemImage.downloadImage(from: URL(string: item.product_img!)!)
            
            return itemCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadPackage()
    }
    
    private func downloadPackage(){
        let downloadPackage = DownloadPackage()
        downloadPackage.delegate = self
        downloadPackage.downloadByTopicId(id: topicId)
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeMoreDetail"{
            let destination = segue.destination as? CosmeticDetailViewController
            let itemIndex = mainTable.indexPathForSelectedRow?.row
            let item = topicItem[itemIndex!]
            print(item.product_id)
            destination?.productId = item.product_id
        }
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
