//
//  ProductModel.swift
//  Cosmetic
//
//  Created by Omp on 1/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    var product_id: String?
    var product_name: String?
    var product_description: String?
    var product_price: Int?
    var categories_name: String?
    var categories_type: String?
    var brand_name: String?
    var product_img: String?
    
    override init(){
        
    }
    
    init(product_name: String, product_description: String, product_price: Int, categories_name: String,categories_type: String, brand_name: String, product_img: String) {
        self.product_name = product_name
        self.product_description = product_description
        self.product_price = product_price
        self.categories_name = categories_name
        self.categories_type = categories_type
        self.brand_name = brand_name
        self.product_img = product_img
        
    }
    
    override var description: String{
        return "ProductName: " + product_name! + "ProductDescription: " + product_description!
    }
}
