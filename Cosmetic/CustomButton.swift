//
//  CustomButton.swift
//  Cosmetic
//
//  Created by Omp on 6/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                backgroundColor = UIColor.init(named: "cosmetic-color-press")
            }else{
                backgroundColor = UIColor.init(named: "cosmetic-color-press")
            }
            
        }
    }

}
