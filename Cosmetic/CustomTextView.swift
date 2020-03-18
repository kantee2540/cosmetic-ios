//
//  CustomTextView.swift
//  Cosmetic
//
//  Created by Omp on 17/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    @IBInspectable var padding: CGFloat = 0
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            setCornerRadius()
        }
    }
    
    func setCornerRadius(){
        layer.cornerRadius = cornerRadius
    }
    
    func setPadding(){
        textContainerInset = UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
    }
    
}
