//
//  DownloadPackage.swift
//  Cosmetic
//
//  Created by Omp on 1/12/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

public protocol DownloadPackageProtocol: class {
    func itemDownloaded(item: NSMutableArray)
}

class DownloadPackage: NSObject {
    
    weak var delegate: DownloadPackageProtocol!
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: String = ""
    
    func downloadByTopicId(id topicId: String){
        postParameter = "topic_id=\(topicId)"
        downloadItem()
    }
    
    func downloadItem(){
        DB_URL = getAddress.getPackageURL()
        
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
                print("Data downloaded - Package")
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
            let product = PackageModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? String,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? String,
                let product_img = jsonElement[ConstantProduct.productImg] as? String,
                let topic_id = jsonElement[ConstantProduct.topicId] as? String,
                let topic_name = jsonElement[ConstantProduct.topicName] as? String,
                let topic_description = jsonElement[ConstantProduct.topicDescription] as? String,
                let topic_code = jsonElement[ConstantProduct.topic_code] as? String
            {
                product.product_id = product_id
                product.product_name = product_name
                product.product_description = product_description
                product.product_price = Int(product_price)
                product.product_img = product_img
                product.topic_id = topic_id
                product.topic_name = topic_name
                product.topic_description = topic_description
                product.topic_code = topic_code
                
            }
            
            products.add(product)
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemDownloaded(item: products)
        })
        
    }
}
