//
//  DownloadSaveTopic.swift
//  Cosmetic
//
//  Created by Omp on 15/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DownloadSaveTopicDelegate {
    func downloadSaveTopicSuccess(item: NSMutableArray)
    func downloadSaveTopicFailed(error: String)
}

class DownloadSaveTopic: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        delegate?.downloadSaveTopicFailed(error: error)
    }
    
    
    var delegate: DownloadSaveTopicDelegate?
    let getAddress = webAddress()
    
    func checkTopicIsSaved(userId: String, topicId: String){
        let DB_URL = getAddress.getSaveTopicURL()
        let param = ["user_id": userId, "topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param)
    }
    
    func downloadSaveTopic(userId: String, orderBy: String){
        let DB_URL = getAddress.getSaveTopicURL()
        let param = ["user_id": userId, "orderby": orderBy]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param)
        
    }
    
    func parseJSON(_ data:Data){
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
            self.delegate?.downloadSaveTopicSuccess(item: products)
        })
        
    }
}
