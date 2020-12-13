//
//  DownloadCosmeticDeskList.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol DownloadCosmeticDeskListDelegate {
    func itemCosmeticDeskDownloaded(item: NSMutableArray)
    func itemCosmeticDeskFailed(error: String)
}

class DownloadCosmeticDeskList: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        self.delegate?.itemCosmeticDeskFailed(error: error)
    }
    
    var delegate: DownloadCosmeticDeskListDelegate?
    
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func getCosmeticDeskByUserid(orderby: String){
        DB_URL = getAddress.getCosmeticDeskList()
        postParameter["orderby"] = orderby
        downloadItem()
    }
    func getFavorite(orderBy: String){
        DB_URL = getAddress.getCosmeticDeskFavoriteList()
        postParameter["orderby"] = orderBy
        downloadItem()
    }
    
    func getCosmeticByLimit(limit: Int){
        DB_URL = getAddress.getCosmeticDeskList()
        postParameter = ["limit": limit]
        downloadItem()
    }
    
    func checkCosmeticIsSaved(productId: Int){
        postParameter = ["product_id" : productId]
        downloadItem()
    }
    
    private func downloadItem(){
        let uid = UserDefaults.standard.string(forKey: ConstantUser.uid)
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: postParameter, header: ["Authorization": String(uid!)])
    }
    
    func parseJSON(_ data:Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }

        var jsonElement = NSDictionary()
        let cosmeticDesks = NSMutableArray()
        
        for i in 0 ..< jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            let cosmeitcDesk = CosmeticDeskModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? Int,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? Int,
                let categories_id = jsonElement[ConstantProduct.categoriesId] as? Int,
                let categories_name = jsonElement[ConstantCategories.categoriesName] as? String,
                let brand_name = jsonElement[ConstantProduct.brandName] as? String,
                let product_img = jsonElement[ConstantProduct.productImg] as? String,
                let ingredient = jsonElement[ConstantProduct.ingredient] as? String,
                let user_id = jsonElement[ConstantUser.userId] as? Int,
                let desk_id = jsonElement[ConstantProduct.deskId] as? Int,
                let favorite = jsonElement[ConstantProduct.favorite] as? Int
            {
                cosmeitcDesk.product_id = product_id
                cosmeitcDesk.product_name = product_name
                cosmeitcDesk.product_description = product_description
                cosmeitcDesk.product_price = Int(product_price)
                cosmeitcDesk.categories_id = categories_id
                cosmeitcDesk.categories_name = categories_name
                cosmeitcDesk.brand_name = brand_name
                cosmeitcDesk.product_img = product_img
                cosmeitcDesk.ingredient = ingredient
                cosmeitcDesk.user_id = user_id
                cosmeitcDesk.desk_id = desk_id
                cosmeitcDesk.favorite = favorite
            }
            
            cosmeticDesks.add(cosmeitcDesk)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemCosmeticDeskDownloaded(item: cosmeticDesks)
        })
        
    }
}
