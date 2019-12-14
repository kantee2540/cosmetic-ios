//
//  DownloadProduct.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

@objc public protocol DownloadProductProtocol: class {
    func itemDownloaded(item: NSMutableArray)
}

@objc class DownloadProduct: NSObject {
    
    @objc weak var delegate: DownloadProductProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func downloadByCategories(categoriesId id: String){
        postParameter = "categories_id=\(id)"
        downloadItem()
    }
    
    func downloadByBrands(brandId id: String){
        postParameter = "brand_id=\(id)"
        downloadItem()
    }
    
    func downloadSelectItem(productId id: String){
        postParameter = "productId=\(id)"
        downloadItem()
    }
    
    func downloadLimitItem(limitNum: Int){
        postParameter = "limit=\(limitNum)"
        downloadItem()
    }
    
    @objc func downloadItem(){
        DB_URL = getAddress.getProductURL()
        
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
    
    @objc func parseJSON(_ data:Data){
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
            let product = ProductModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? String,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? String,
                let categories_id = jsonElement[ConstantProduct.categoriesId] as? String,
                let categories_name = jsonElement[ConstantProduct.categoriesName] as? String,
                let categories_type = jsonElement[ConstantProduct.categoriesType] as? String,
                let brand_name = jsonElement[ConstantProduct.brandName] as? String,
                let product_img = jsonElement[ConstantProduct.productImg] as? String,
                let ingredient = jsonElement[ConstantProduct.ingredient] as? String
            {
                product.product_id = product_id
                product.product_name = product_name
                product.product_description = product_description
                product.product_price = Int(product_price)
                product.categories_id = categories_id
                product.categories_name = categories_name
                product.categories_type = categories_type
                product.brand_name = brand_name
                product.product_img = product_img
                product.ingredient = ingredient
                
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemDownloaded(item: products)
        })
        
    }
}


