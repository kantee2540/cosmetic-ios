//
//  DownloadDrawerCollection.swift
//  Cosmetic
//
//  Created by Omp on 20/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol DownloadDrawerCollectionDelegate {
    func itemDrawerCollectionSuccess(item: NSMutableArray)
    func itemDrawerCollectionFailed(error: String)
}

class DownloadDrawerCollection: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        delegate?.itemDrawerCollectionFailed(error: error)
    }
    
    
    var delegate: DownloadDrawerCollectionDelegate?
    let getAddress = webAddress()
    
    func downloadDrawerCollection(userId : String, drawerId: String){
        let DB_URL = getAddress.getDrawerCollectionURL()
        let param = ["user_id": userId, "drawer_id": drawerId]
        
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
            let product = DrawerCollectionModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? String,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? String,
                let categories_id = jsonElement[ConstantProduct.categoriesId] as? String,
                let brand_name = jsonElement[ConstantProduct.brandName] as? String,
                let product_img = jsonElement[ConstantProduct.productImg] as? String,
                let ingredient = jsonElement[ConstantProduct.ingredient] as? String,
                let drawer_collection_id = jsonElement["drawer_collection_id"] as? String
                
            {
                product.product_id = product_id
                product.product_name = product_name
                product.product_description = product_description
                product.product_price = Int(product_price)
                product.categories_id = categories_id
                product.brand_name = brand_name
                product.product_img = product_img
                product.ingredient = ingredient
                product.drawer_collection_id = drawer_collection_id
                
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDrawerCollectionSuccess(item: products)
        })
        
    }
}
