//
//  SaveTopicTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 14/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class SaveTopicTableViewController: UITableViewController, DownloadSaveTopicDelegate, SaveTopicDelegate {
    func saveTopicSuccess() {
        self.tableView.reloadData()
        downloadSaveTopic(userId: userId!)
        removeSpinner()
    }
    
    func saveTopicFailed() {
        Library.displayAlert(targetVC: self, title: "Error", message: "Cannot delete this save topic")
    }
    
    func downloadSaveTopicSuccess(item: NSMutableArray) {
        savedItem = item as! [TopicModel]
        //countLabel.text = "You have \(savedItem.count) saved topics"
        self.tableView.reloadData()
    }
    
    func downloadSaveTopicFailed(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {(action) -> Void in
            self.downloadSaveTopic(userId: self.userId!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var countLabel: UILabel!
    
    private var userId: String?
    private var savedItem: [TopicModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        if userId != nil{
            downloadSaveTopic(userId: userId!)
        }else{
            savedItem.removeAll()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Saved Beauty set"
        
        let nologinVc = (self.storyboard?.instantiateViewController(identifier: "nologin")) as! NoLoginViewController
        let viewControllers: [UIViewController] = self.children
        if userId != nil{
            for vcs in viewControllers{
                vcs.willMove(toParent: nil)
                vcs.view.removeFromSuperview()
                vcs.removeFromParent()
            }
        }else{
            add(nologinVc)
        }
    }
    
    private func downloadSaveTopic(userId: String){
        let downloadSaveTopic = DownloadSaveTopic()
        downloadSaveTopic.delegate = self
        downloadSaveTopic.downloadSaveTopic(userId: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seetopic"{
            let destination = segue.destination as! TopTopicViewController
            let index = self.tableView.indexPathForSelectedRow?.row
            let item = savedItem[index!]
            destination.topicId = item.topic_id
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedItem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topiccell", for: indexPath) as! MyTopicTableViewCell
        let item = savedItem[indexPath.row]
        // Configure the cell...
        
        cell.titleLabel.text = item.topic_name
        cell.descriptionLabel.text = item.topic_description
        if item.topic_img != ""{
            cell.topicImage.downloadImage(from: URL(string: item.topic_img!)!)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            showSpinner(onView: self.view)
            let item = savedItem[indexPath.row]
            
            let saveTopic = SaveTopic()
            saveTopic.delegate = self
            saveTopic.deleteTopic(topicId: item.topic_id!, userId: userId!)
        }
    }
}
