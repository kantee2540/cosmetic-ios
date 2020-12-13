//
//  InsertItemToDesk.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol CosmeticDeskDelegate {
    func onSuccess(isSave: Bool)
    func checkedItem(isSave: Bool)
    func onFailed()
}

class CosmeticDesk: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        DispatchQueue.main.async(execute: { () -> Void in
            var jsonResult = NSDictionary()
            let dataObj = data
            
            do{
                jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            }catch let error as NSError{
                print(error)
            }
            
            if let isSaved = jsonResult["is_saved"] as? Bool{
                self.delegate?.checkedItem(isSave: isSaved)
            }
            
            if let error = jsonResult["error"] as? Bool{
                if !error{
                    self.delegate?.onSuccess(isSave: jsonResult["is_saved"] as! Bool)
                }else{
                    self.delegate?.onFailed()
                }
            }
        })
    }
    
    func downloadFailed(error: String) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.onFailed()
        })
    }
    
    var delegate: CosmeticDeskDelegate?
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    var header: [String: String] = [:]
    
    func checkItem(productId: Int){
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        DB_URL = getAddress.getCheckItem()
        postParameter = ["product_id": productId]
        header = ["Authorization": String(uid!)]
        processing()
    }
    
    func insertToDesk(productId: Int){
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        DB_URL = getAddress.getInsertItemToDesk()
        postParameter = ["product_id": productId]
        header = ["Authorization": String(uid!)]
        processing()
    }
    
    func deleteFromDesk(productId: Int) {
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        DB_URL = getAddress.getDeleteItemFromDesk()
        postParameter = ["product_id": productId]
        header = ["Authorization": String(uid!)]
        processing()
    }
    
    private func processing(){
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParameter, header: header)
    }
}
