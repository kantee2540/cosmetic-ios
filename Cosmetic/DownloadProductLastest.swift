//
//  File.swift
//  Cosmetic
//
//  Created by Omp on 5/7/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import Foundation

import UIKit

@objc public protocol DownloadLastestProductProtocol: class {
    func itemDownloadedProductLastest(item: NSMutableArray)
}

@objc class DownloadProductLastest: NSObject {
    
    @objc weak var delegate: DownloadLastestProductProtocol!
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    
    @objc func downloadItem(){
        DB_URL = getAddress.getProductURL()
        
        //Get data from database
        var request = URLRequest(url: URL(string: DB_URL)!)
        request.httpMethod = "POST"
        
        let postParameter = "sql=SELECT * FROM product p JOIN product_brand b ON p.brand_id = b.brand_id JOIN categories c ON p.categories_id = c.categories_id LIMIT 5"
        request.httpBody = postParameter.data(using: .utf8)
        
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
            
            if let product_name = jsonElement["product_name"] as? String,
                let product_description = jsonElement["description"] as? String,
                let product_price = jsonElement["product_price"] as? String,
                let categories_name = jsonElement["categories_name"] as? String,
                let categories_type = jsonElement["categories_type"] as? String,
                let brand_name = jsonElement["brand_name"] as? String,
                let product_img = jsonElement["product_img"] as? String
            {
                product.product_name = product_name
                product.product_description = product_description
                product.product_price = product_price
                product.categories_name = categories_name
                product.categories_type = categories_type
                product.brand_name = brand_name
                product.product_img = product_img
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemDownloadedProductLastest(item: products)
        })
        
    }
}


