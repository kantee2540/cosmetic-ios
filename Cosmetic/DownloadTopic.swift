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
    func topicGetItem(detail: TopicModel, packages: NSMutableArray)
    func topicError(error: String)
}

class DownloadTopic: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        delegate?.topicError(error: error)
    }
    
    weak var delegate: DownloadTopicProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func downloadLimitTopic(limit lim: Int){
        postParameter["limit"] = lim
        downloadItem()
    }
    func downloadTopLimitTopic(limit lim: Int){
        postParameter["top_limit"] = lim
        downloadItem()
    }
    
    func getTopicById(topicId id: Int){
        //postParameter["topic_id"] = id
        downloadOneItem(topicId: id)
    }
    
    func getTopicByUserId(userId id: String){
        postParameter["user_id"] = id
        downloadItem()
    }
    
    func getTopicId(code topicCode: String){
        postParameter["topic_code"] = topicCode
        downloadItem()
    }
    
    func downloadItem(){
        DB_URL = getAddress.getTopicURL()
        
        let network = Network()
        network.delegate = self
        network.get(URL: DB_URL, param: postParameter)
        
    }
    
    func downloadOneItem(topicId id: Int){
        DB_URL = getAddress.getTopicURL() + "/\(id)"
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.get(DB_URL, parameters: nil, headers: nil, progress: {(Progress) in },
                     success: {(Operation, responseObject) in
                        do{
                            let json = try JSONSerialization.jsonObject(with: responseObject as! Data, options: .mutableContainers) as! [String: Any]
                            let topicDetail :[String: Any] = json["data"] as! [String : Any]
                            let topic = TopicModel()
                            topic.topic_id = topicDetail[ConstantProduct.topicId] as? Int
                            topic.topic_name = topicDetail[ConstantProduct.topicName] as? String
                            topic.topic_description = topicDetail[ConstantProduct.topicDescription] as? String
                            topic.topic_code = topicDetail[ConstantProduct.topic_code] as? String
                            topic.topic_img = topicDetail[ConstantProduct.topic_img] as? String
                            topic.user_id = topicDetail[ConstantUser.userId] as? Int
                            topic.nickname = topicDetail[ConstantUser.nickName] as? String
                            topic.userImg = topicDetail[ConstantUser.profilepic] as? String
                            topic.likeCount = json["like_count"] as? Int
                            
                            let packagesData = json["packages"] as! NSArray
                            let packages = NSMutableArray()
                            for i in packagesData{
                                let item = i as! [String: Any]
                                let package = PackageModel()
                                package.product_id = item[ConstantProduct.productId] as? Int
                                package.product_name = item[ConstantProduct.productName] as? String
                                package.product_price = item[ConstantProduct.productPrice] as? Int
                                package.product_img = item[ConstantProduct.productImg] as? String
                                package.categories_name = item[ConstantProduct.categoriesName] as? String
                                
                                packages.add(package)
                            }
                            
                            self.delegate?.topicGetItem(detail: topic, packages: packages)
                        } catch let error as NSError{
                            print(error)
                        }
                     },
                     failure: {(Operation, error) in
                        
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
        let topics = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let topic = TopicModel()
            
            if  let topic_id = jsonElement[ConstantProduct.topicId] as? Int,
                let topic_name = jsonElement[ConstantProduct.topicName] as? String,
                let topic_description = jsonElement[ConstantProduct.topicDescription] as? String,
                let topic_code = jsonElement[ConstantProduct.topic_code] as? String,
                let topic_img = jsonElement[ConstantProduct.topic_img] as? String,
                let user_id = jsonElement[ConstantUser.userId] as? Int,
                let nickname = jsonElement[ConstantUser.nickName] as? String,
                let profilePic = jsonElement[ConstantUser.profilepic] as? String
            {
                topic.topic_id = topic_id
                topic.topic_name = topic_name
                topic.topic_description = topic_description
                topic.topic_code = topic_code
                topic.topic_img = topic_img
                topic.user_id = user_id
                topic.nickname = nickname
                topic.userImg = profilePic
                
            }
            
            topics.add(topic)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.topicDownloaded(item: topics)
        })
        
    }
}
