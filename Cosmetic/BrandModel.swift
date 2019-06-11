//
//  BrandModel.swift
//  Cosmetic
//
//  Created by Omp on 18/5/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

@objc class BrandModel: NSObject {
    @objc var brand_id :String?
    @objc var brand_name :String?
    @objc var brand_logo :String?
    
    override init() {
        
    }
    
    @objc init(brand_id: String, brand_name: String, brand_logo: String) {
        self.brand_id = brand_id
        self.brand_name = brand_name
        self.brand_logo = brand_logo
    }
    
}
