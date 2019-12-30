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

class DownloadNotification: NSObject {
    var delegate: DownloadNotificationDelegate?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    @objc func downloadItem(){
        DB_URL = getAddress.getNotificationURL()
        
        //Get data from database
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Download data")
                
            }else{
                print("Data downloaded - Notification")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
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
