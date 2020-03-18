//
//  DownloadTopic.swift
//  Cosmetic
//
//  Created by Omp on 1/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AFNetworking

public protocol DownloadTopicProtocol: class{
    func topicDownloaded(item: NSMutableArray)
}

class DownloadTopic: NSObject {
    weak var delegate: DownloadTopicProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func downloadLimitTopic(limit lim: Int){
        postParameter["topic_limit"] = lim
        downloadItem()
    }
    
    func getTopicId(code topicCode: String){
        postParameter["topic_code"] = topicCode
        downloadItem()
    }
    
    func downloadItem(){
        DB_URL = getAddress.getTopicURL()
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(DB_URL, parameters: postParameter, success: {
            (operation: AFHTTPRequestOperation, responseObject: Any) in
            self.parseJSON(responseObject as! Data)
        }, failure: {
            (opefation: AFHTTPRequestOperation?, error: Error) in
            print("Error = \(error)")
        })
        
    }
    
    @objc func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        

        var jsonElement = NSDictionary()
        let products = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let product = TopicModel()
            
            if  let topic_id = jsonElement[ConstantProduct.topicId] as? String,
                let topic_name = jsonElement[ConstantProduct.topicName] as? String,
                let topic_description = jsonElement[ConstantProduct.topicDescription] as? String,
                let topic_code = jsonElement[ConstantProduct.topic_code] as? String,
                let topic_img = jsonElement[ConstantProduct.topic_img] as? String
            {
                product.topic_id = topic_id
                product.topic_name = topic_name
                product.topic_description = topic_description
                product.topic_code = topic_code
                product.topic_img = topic_img
                
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.topicDownloaded(item: products)
        })
        
    }
}
