//
//  NoficationTableViewController.swift
//  Cosmetic
//
//  Created by Omp on 30/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class NoficationTableViewController: UITableViewController, DownloadNotificationDelegate {
    
    @IBOutlet var notificationTable: UITableView!
    private var notiList: [NotificationModel] = []
    
    func itemDownloaded(item: NSMutableArray) {
        notiList = item as! [NotificationModel]
        notificationTable.reloadData()
        self.removeSpinner()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        notificationTable.delegate = self
        notificationTable.dataSource = self
        let downloadNotification = DownloadNotification()
        downloadNotification.delegate = self
        downloadNotification.downloadItem()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notiList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notification", for: indexPath) as! NotificationTableViewCell
        let item = notiList[indexPath.row]
        cell.titleLabel.text = item.notiTitle
        cell.contentLabel.text = item.notiContent
        cell.dateLabel.text = setDateFormat(date: item.notiDate!)
        
        // Configure the cell...

        return cell
    }
    
    private func setDateFormat(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: dateObj)
    }
    
}
