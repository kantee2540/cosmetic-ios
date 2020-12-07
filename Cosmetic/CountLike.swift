//
//  LikeDislike.swift
//  Cosmetic
//
//  Created by Omp on 28/5/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol LikeDislikeDelegate {
    func getLikeDislikeSuccess(like: Int)
    func getLikeDislikeFailed(error: String)
}

class CountLike: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        fetchData(data: data)
    }
    
    func downloadFailed(error: String) {
        delegate?.getLikeDislikeFailed(error: error)
    }
    
    var delegate :LikeDislikeDelegate?
    let getAddress = webAddress()
    
    func fetchData(data: Data){
        var jsonResult = NSDictionary()
        let dataObj = data
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        }catch let error as NSError{
            print(error)
        }
        
        if let countLike = jsonResult["countlike"] as? String{
            self.delegate?.getLikeDislikeSuccess(like: Int(countLike)!)
        }else{
            self.delegate?.getLikeDislikeFailed(error: "Failed to get data")
        }
    }
}
