//
//  DownloadNotification.swift
//  Cosmetic
//
//  Created by Omp on 31/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

protocol DownloadNotificationDelegate {
    func itemDownloaded(item: NSMutableArray)
}

class DownloadNotification: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        
    }
    
    var delegate: DownloadNotificationDelegate?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    @objc func downloadItem(){
        DB_URL = getAddress.getNotificationURL()
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: [:])
    }
    
    @objc func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        
        var jsonElement = NSDictionary()
        let notifications = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let notification = NotificationModel()
            
            if let notiId = jsonElement[ConstantNotification.notiId] as? String,
                let notiTitle = jsonElement[ConstantNotification.notiTitle] as? String,
                let notiContent = jsonElement[ConstantNotification.notiContent] as? String,
                let notiDate = jsonElement[ConstantNotification.notiDate] as? String
                
            {
                notification.notiId = notiId
                notification.notiTitle = notiTitle
                notification.notiContent = notiContent
                notification.notiDate = notiDate
            }
            
            notifications.add(notification)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloaded(item: notifications)
        })
    }
}
