//
//  MyTopicTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 3/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialSnackbar

class MyTopicTableViewController: UITableViewController, DownloadTopicProtocol, RemoveTopicDelegate, ShareBeautysetDelegate {
    func finishedCreateset() {
        downloadTopic()
        let answerMessage = MDCSnackbarMessage()
        answerMessage.text = "Updated beauty set"
        MDCSnackbarManager().show(answerMessage)
    }
    
    func removeSuccess() {
        downloadTopic()
        removeSpinner()
        let answerMessage = MDCSnackbarMessage()
        answerMessage.text = "Removed beauty from account"
        MDCSnackbarManager().show(answerMessage)
    }
    
    func removeFailed(error: String) {
        Library.displayAlert(targetVC: self, title: "Error", message: error)
    }
    
    func topicGetItem(detail: TopicModel, packages: NSMutableArray) {
        
    }
    
    func topicDownloaded(item: NSMutableArray) {
        topicList = item as! [TopicModel]
        self.tableView.reloadData()
    }
    
    func topicError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private var topicList: [TopicModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        downloadTopic()
    }
    
    private func downloadTopic(){
        let downloadTopic = DownloadTopic()
        downloadTopic.delegate = self
        downloadTopic.getTopicByUserId()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seetopic"{
            let index = self.tableView.indexPathForSelectedRow?.row
            let item = topicList[index!]
            let destination = segue.destination as? TopTopicViewController
            destination?.topicId = item.topic_id
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topicList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topiccell", for: indexPath) as? MyTopicTableViewCell
        // Configure the cell...
        let item = topicList[indexPath.row]
        
        cell?.titleLabel.text = item.topic_name
        cell?.descriptionLabel.text = item.topic_description
        cell?.topicCodeLabel.text = "Code : \(item.topic_code ?? "000000")"
        
        if item.topic_img != ""{
            cell?.topicImage.downloadImage(from: URL(string: item.topic_img!) ?? URL(string: ConstantDefaultURL.defaultImageURL)!)
        }else{
            cell?.topicImage.image = UIImage(named: "bg4")
        }

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = topicList[indexPath.row]
        
        let FlagAction = UIContextualAction(style: .normal, title:  "Edit", handler: {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if let rootVc = self.storyboard?.instantiateViewController(withIdentifier: "sharesetroot") as? ShareBeautysetRootViewController{
                let shareVc = rootVc.viewControllers.first as? ShareBeautysetViewController
                rootVc.topicId = item.topic_id
                shareVc?.delegate = self
                self.present(rootVc, animated: true, completion: nil)
            }
            
            success(true)
        })
        FlagAction.backgroundColor = .lightGray
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: {
            (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Are you sure to delete this beauty set?", message: "\"\(item.topic_name!)\" will deleted. You can't undo this action.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                self.showSpinner(onView: self.view)
                let topic = Topic()
                topic.removeDelegate = self
                topic.removeTopic(id: item.topic_id!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
            }))
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction, FlagAction])
    }
}
