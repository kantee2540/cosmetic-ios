//
//  SaveTopicTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 14/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class SaveTopicTableViewController: UITableViewController, DownloadSaveTopicDelegate {
    func downloadSaveTopicSuccess(item: NSMutableArray) {
        savedItem = item as! [TopicModel]
        self.tableView.reloadData()
    }
    
    func downloadSaveTopicFailed() {
        
    }
    
    private var savedItem: [TopicModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let userId = UserDefaults.standard.string(forKey: ConstantUser.userId)
        
        let downloadSaveTopic = DownloadSaveTopic()
        downloadSaveTopic.delegate = self
        downloadSaveTopic.downloadSaveTopic(userId: userId!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
}
