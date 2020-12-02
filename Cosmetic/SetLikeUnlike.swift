//
//  SetLikeUnlike.swift
//  Cosmetic
//
//  Created by Omp on 28/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol SetLikeUnlikeDelegate {
    func setLikeUnlikeSuccess(like: Bool)
    func setLikeUnlikeFailed(error: String)
}

class SetLikeUnlike: NSObject, NetworkDelegate{
    func downloadSuccess(data: Data) {
        var jsonResult = NSDictionary()
        let dataObj = data
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        }catch let error as NSError{
            print(error)
        }
        
        if let countLike = jsonResult["like"] as? Bool{
            self.delegate?.setLikeUnlikeSuccess(like: countLike)
        }else{
            self.delegate?.setLikeUnlikeFailed(error: "Failed to get data")
        }
        
    }
    
    func downloadFailed(error: String) {
        delegate?.setLikeUnlikeFailed(error: error)
    }
    
    
    var delegate: SetLikeUnlikeDelegate?
    let getAddress = webAddress()
    
    func like(userId: Int, topicId: Int){
        let DB_URL = getAddress.getSetLike()
        let param = ["user_id": userId, "topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["":""])
        
    }
    
    func checkLike(userId: Int, topicId: Int){
        let DB_URL = getAddress.getCheckLikeURL()
        let param = ["user_id": userId, "topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["":""])
    }
    
}
