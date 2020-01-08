//
//  DownloadCosmeticDeskList.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DownloadCosmeticDeskListDelegate {
    func itemCosmeticDeskDownloaded(item: NSMutableArray)
}

class DownloadCosmeticDeskList: NSObject {

    var delegate: DownloadCosmeticDeskListDelegate?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func getCosmeticDeskByUserid(userId: String){
        postParameter = "user_id=\(userId)"
        downloadItem()
    }
    
    func checkCosmeticIsSaved(userId: String, productId: String){
        postParameter = "user_id=\(userId)&product_id=\(productId)"
        downloadItem()
    }
    
    private func downloadItem(){
        DB_URL = getAddress.getCosmeticDeskList()
        
        //Get data from database
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        if postParameter != ""{
            request.httpBody = postParameter.data(using: .utf8)
        }
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Failed to Download data")
                
            }else{
                print("Data downloaded - Product")
                self.parseJSON(data!)
            }
            
        }
        task.resume()
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
            let product = CosmeticDeskModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? String,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? String,
                let categories_id = jsonElement[ConstantProduct.categoriesId] as? String,
                let brand_name = jsonElement[ConstantProduct.brandName] as? String,
                let product_img = jsonElement[ConstantProduct.productImg] as? String,
                let ingredient = jsonElement[ConstantProduct.ingredient] as? String,
                let user_id = jsonElement[ConstantUser.userId] as? String,
                let desk_id = jsonElement[ConstantProduct.deskId] as? String
            {
                product.product_id = product_id
                product.product_name = product_name
                product.product_description = product_description
                product.product_price = Int(product_price)
                product.categories_id = categories_id
                product.brand_name = brand_name
                product.product_img = product_img
                product.ingredient = ingredient
                product.user_id = user_id
                product.desk_id = desk_id
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemCosmeticDeskDownloaded(item: products)
        })
        
    }
}
