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

class AddTopic: NSObject {
    
    var delegate: AddTopicDelegate?
    let getAddress = webAddress()

    func insertTopic(topic_name: String, topic_desc: String, user_id: Int, productSet: [Any], image: UIImage?){
        
        let URL = getAddress.getInsertTopicURL()
        
        let param = ["topic_name": topic_name,
                     "topic_desc": topic_desc,
                     "user_id": user_id,
                     "productset": convertToJson(from: productSet) as Any] as [String : Any]

        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()

        manager.post(URL, parameters: param, headers: nil, constructingBodyWith: { (data:AFMultipartFormData!) -> Void in
            if image != nil{
                data.appendPart(withFileData: (image?.jpegData(compressionQuality: 0.75))!, name: "imageFile", fileName: topic_name, mimeType: "image/jpeg")
            }
        },progress: {(Progress) in}, success: {
            (operation: URLSessionDataTask, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                var jsonResult = NSArray()
                let dataObj = responseObject as! Data
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                }catch let error as NSError{
                    print(error)
                }

                var jsonElement = NSDictionary()
                
                jsonElement = jsonResult[0] as! NSDictionary
                if let topicCode = jsonElement["topic_code"]{
                    print("topicCode => \(topicCode)")
                    self.delegate?.insertTopicSuccess(topicCode: topicCode as! String)
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
        
//        manager.post(URL, parameters: param, success: {
//            (operation: AFHTTPRequestOperation, responseObject: Any) in
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.delegate?.insertTopicSuccess()
//            })
//        }, failure: {
//            (opefation: AFHTTPRequestOperation?, error: Error) in
//            print(error)
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.delegate?.insertTopicFailed(error: error.localizedDescription)
//            })
//        })
    }
    
    func insertTopicWithOutImage(topic_name: String, topic_desc: String, user_id: Int, productSet: [Any]){
        
        let URL = getAddress.getInsertTopicURL()
        
        let param = ["topic_name": topic_name,
                     "topic_desc": topic_desc,
                     "user_id": user_id,
                     "productset": convertToJson(from: productSet) as Any] as [String : Any]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(URL, parameters: param, headers: nil,progress: {(Progress) in }, success: {
            (operation: URLSessionDataTask, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                
                var jsonResult = NSArray()
                let dataObj = responseObject as! Data
                
                do{
                    jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                }catch let error as NSError{
                    print(error)
                }

                var jsonElement = NSDictionary()
                
                jsonElement = jsonResult[0] as! NSDictionary
                if let topicCode = jsonElement["topic_code"]{
                    print("topicCode => \(topicCode)")
                    self.delegate?.insertTopicSuccess(topicCode: topicCode as! String)
                }else{
                    self.delegate?.insertTopicFailed(error: "Can't post beauty kit")
                }
            })
        }, failure: {
            (opefation: URLSessionDataTask?, error: Error) in
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
}
