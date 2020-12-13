//
//  SetLikeUnlike.swift
//  Cosmetic
//
//  Created by Omp on 28/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol SetLikeUnlikeDelegate {
    func setLikeUnlikeSuccess(like: Bool, currentLike: Int)
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
        
        if let countLike = jsonResult["is_liked"] as? Bool,
           let currentLike = jsonResult["current_like"] as? Int{
            self.delegate?.setLikeUnlikeSuccess(like: countLike, currentLike: currentLike)
        }else{
            self.delegate?.setLikeUnlikeFailed(error: "Failed to get data")
        }
        
    }
    
    func downloadFailed(error: String) {
        delegate?.setLikeUnlikeFailed(error: error)
    }
    
    
    var delegate: SetLikeUnlikeDelegate?
    let getAddress = webAddress()
    
    func like(topicId: Int){
        let DB_URL = getAddress.getSetLike()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header:["Authorization": String(uid!)])
        
    }
    
    func unlike(topicId: Int){
        let DB_URL = getAddress.getSetunlike()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header:["Authorization": String(uid!)])
        
    }
    
    func checkLike(topicId: Int){
        let DB_URL = getAddress.getCheckLikeURL()
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        let param = ["topic_id": topicId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["Authorization": String(uid!)])
    }
    
}
