//
//  DownloadProduct.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit
import AFNetworking

public protocol DownloadProductProtocol: class {
    func itemDownloaded(item: NSMutableArray)
    func itemDownloadFailed(error_mes: String)
}

class DownloadProduct: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        self.parseJSON(data)
    }
    
    func downloadFailed(error: String) {
        self.delegate?.itemDownloadFailed(error_mes: error)
    }
    
    
    weak var delegate: DownloadProductProtocol?
    //Change this if URL of database is changed
    let getAddress = webAddress()
    var DB_URL:String!
    var postParameter: [String: Any] = [:]
    
    func downloadByCategoriesAndBrand(categoriesId: String, brandId: String, minPrice: Int?, maxPrice: Int?){
        DB_URL = getAddress.getProductURL()
        postParameter["categories_id"] = categoriesId
        postParameter["brand_id"] = brandId
        if minPrice != nil && maxPrice != nil{
            postParameter["pricemin"] = minPrice
            postParameter["pricemax"] = maxPrice
        }else if minPrice != nil{
            postParameter["pricemin"] = minPrice
        }else if maxPrice != nil{
            postParameter["pricemax"] = maxPrice
        }
        downloadItem()
    }
    
    func downloadByCategories(categoriesId id: String, minPrice: Int?, maxPrice: Int?){
        DB_URL = getAddress.getProductURL()
        postParameter["categories_id"] = id
        if minPrice != nil && maxPrice != nil{
            postParameter["pricemin"] = minPrice
            postParameter["pricemax"] = maxPrice
        }else if minPrice != nil{
            postParameter["pricemin"] = minPrice
        }else if maxPrice != nil{
            postParameter["pricemax"] = maxPrice
        }
        downloadItem()
    }
    func searchByKeyword(_ keyword: String){
        DB_URL = getAddress.getProductURL()
        postParameter["keyword"] = keyword
        downloadItem()
    }
    
    func downloadByBrands(brandId id: String, minPrice: Int?, maxPrice: Int?){
        DB_URL = getAddress.getProductURL()
        postParameter["brand_id"] = id
        if minPrice != nil && maxPrice != nil{
            postParameter["pricemin"] = minPrice
            postParameter["pricemax"] = maxPrice
        }else if minPrice != nil{
            postParameter["pricemin"] = minPrice
        }else if maxPrice != nil{
            postParameter["pricemax"] = maxPrice
        }
        downloadItem()
    }
    
    func downloadByPrice(minPrice min: Int, maxPrice max: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["pricemin"] = min
        postParameter["pricemax"] = max
        
        downloadItem()
    }
    
    func downloadByMinPrice(minPrice min: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["pricemin"] = min
        downloadItem()
    }
    
    func downloadByMaxPrice(maxPrice max: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["pricemax"] = max
        downloadItem()
    }
    
    func downloadSelectItem(productId id: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["productId"] = id
        downloadItem()
    }
    
    func downloadLimitItem(limitNum: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["limit"] = limitNum
        downloadItem()
    }
    
    func downloadSort(sort: Int){
        DB_URL = getAddress.getProductURL()
        postParameter["sort"] = sort
        downloadItem()
    }
    
    func downloadItem(){
        
        
        let network = Network()
        network.delegate = self
        network.get(URL: DB_URL, param: postParameter)
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
            let product = ProductModel()
            
            if  let product_id = jsonElement[ConstantProduct.productId] as? Int,
                let product_name = jsonElement[ConstantProduct.productName] as? String,
                let product_description = jsonElement[ConstantProduct.description] as? String,
                let product_price = jsonElement[ConstantProduct.productPrice] as? Int,
                let categories_id = jsonElement[ConstantProduct.categoriesId] as? Int,
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


