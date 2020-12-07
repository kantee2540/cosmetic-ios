//
//  AddTopic.swift
//  Cosmetic
//
//  Created by Omp on 2/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol AddTopicDelegate {
    func insertTopicSuccess(topicCode: String)
    func insertTopicFailed(error: String)
}

protocol RemoveTopicDelegate {
    func removeSuccess()
    func removeFailed(error: String)
}

class Topic: NSObject {
    
    var delegate: AddTopicDelegate?
    var removeDelegate: RemoveTopicDelegate?
    let getAddress = webAddress()

    func insertTopic(topic_name: String, topic_desc: String, productSet: [Any], image: UIImage?){
        
        let URL = getAddress.getInsertTopicURL()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_name": topic_name,
                     "topic_desc": topic_desc,
                     "productset": convertToJson(from: productSet) as Any] as [String : Any]

        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()

        manager.post(URL, parameters: param, headers: ["Authorization": String(uid!)], constructingBodyWith: { (data:AFMultipartFormData!) -> Void in
            if image != nil{
                data.appendPart(withFileData: (image?.jpegData(compressionQuality: 0.75))!, name: "topic_image", fileName: topic_name+".jpg", mimeType: "image/jpeg")
            }
        },progress: {(Progress) in}, success: {
            (operation: URLSessionDataTask, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                var jsonResult = NSDictionary()
                let dataObj = responseObject as! Data
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                }catch let error as NSError{
                    print(error)
                    self.delegate?.insertTopicFailed(error: "Can't post beauty kit")
                }
                
                if let error = jsonResult["error"] as? Bool{
                    if !error{
                        let topicCode = jsonResult["topic_code"]
                        self.delegate?.insertTopicSuccess(topicCode: topicCode as! String)
                    }else{
                        self.delegate?.insertTopicFailed(error: "Can't post beauty kit")
                    }
                    
                }else{
                    self.delegate?.insertTopicFailed(error: "Can't post beauty kit")
                }
            })
        }, failure: {
            (Operation, error) in
            print(error)
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.insertTopicFailed(error: error.localizedDescription)
            })
        })
    }
    
    func convertToJson(from object: [Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else{
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func removeTopic(id topicId: Int){
        let URL = getAddress.removeTopicURL()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        let header = ["Authorization": String(uid!)]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.post(URL, parameters: param, headers: header, progress: {(progress) in}, success: {(operation: URLSessionDataTask, responseObject: Any) in
            
            var jsonResult = NSDictionary()
            let dataObj = responseObject as! Data
            
            do{
                jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            }catch let error as NSError{
                print(error)
                self.delegate?.insertTopicFailed(error: "Can't remove beauty kit")
            }
            
            if let error = jsonResult["error"] as? Bool{
                if !error{
                    self.removeDelegate?.removeSuccess()
                }else{
                    self.removeDelegate?.removeFailed(error: "Remove beauty set failed")
                }
            }
            
        }, failure:{
            (Operation, error) in
            self.removeDelegate?.removeFailed(error: "Remove beauty set failed")
        })
    }
}
