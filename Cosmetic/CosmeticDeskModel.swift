//
//  CosmeticDeskModel.swift
//  Cosmetic
//
//  Created by Omp on 8/1/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CosmeticDeskModel: NSObject, NSCoding {
    
    var desk_id: Int?
    var user_id: Int?
    var product_id: Int?
    var product_name: String?
    var product_description: String?
    var product_price: Int?
    var categories_id: Int?
    var categories_name: String?
    var brand_name: String?
    var product_img: String?
    var ingredient: String?
    var favorite: Int?
    
    override init() {
        
    }
    
    init(desk_id: Int, user_id: Int, product_id: Int, product_name: String, product_description: String, product_price: Int, categories_id: Int, categories_name: String, brand_name: String, product_img: String, ingredient: String) {
        self.desk_id = desk_id
        self.user_id = user_id
        self.product_id = product_id
        self.product_name = product_name
        self.product_description = product_description
        self.product_price = product_price
        self.categories_id = categories_id
        self.categories_name = categories_name
        self.brand_name = brand_name
        self.product_img = product_img
        self.ingredient = ingredient
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let desk_id = aDecoder.decodeObject(forKey: ConstantProduct.deskId) as? Int
        let user_id = aDecoder.decodeObject(forKey: ConstantUser.userId) as? Int
        let product_id = aDecoder.decodeObject(forKey: ConstantProduct.productId) as? Int
        let product_name = aDecoder.decodeObject(forKey: ConstantProduct.productName) as? String
        let product_description = aDecoder.decodeObject(forKey: ConstantProduct.description) as? String
        let product_price = aDecoder.decodeObject(forKey: ConstantProduct.productPrice) as? Int
        let categories_id = aDecoder.decodeObject(forKey: ConstantProduct.categoriesId) as? Int
        let categories_name = aDecoder.decodeObject(forKey: ConstantProduct.categoriesName) as? String
        let brand_name = aDecoder.decodeObject(forKey: ConstantProduct.brandName) as? String
        let product_img = aDecoder.decodeObject(forKey: ConstantProduct.productImg) as? String
        let ingredient = aDecoder.decodeObject(forKey: ConstantProduct.productImg) as? String
        
        self.init(desk_id: desk_id ?? 0, user_id: user_id ?? 0, product_id: product_id ?? 0, product_name: product_name ?? "", product_description: product_description ?? "", product_price: product_price ?? 0, categories_id: categories_id ?? 0, categories_name: categories_name ?? "", brand_name: brand_name ?? "", product_img: product_img ?? "", ingredient: ingredient ?? "")
    }
    
    func encode(with acoder: NSCoder) {
        acoder.encode(self.desk_id, forKey: ConstantProduct.deskId)
        acoder.encode(self.product_id, forKey: ConstantProduct.productId)
        acoder.encode(self.product_name, forKey: ConstantProduct.productName)
        acoder.encode(self.product_description, forKey: ConstantProduct.description)
        acoder.encode(self.product_price, forKey: ConstantProduct.productPrice)
        acoder.encode(self.categories_id, forKey: ConstantProduct.categoriesId)
        acoder.encode(self.categories_name, forKey: ConstantProduct.categoriesName)
        acoder.encode(self.brand_name, forKey: ConstantProduct.brandName)
        acoder.encode(self.product_img, forKey: ConstantProduct.productImg)
        acoder.encode(self.ingredient, forKey: ConstantProduct.ingredient)
        
    }
}
