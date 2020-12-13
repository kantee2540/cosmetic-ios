//
//  ShareBeautysetRootViewController.swift
//  Cosmetic
//
//  Created by Omp on 8/12/2563 BE.
//  Copyright © 2563 BE Omp. All rights reserved.
//

import UIKit

class ShareBeautysetRootViewController: UINavigationController {

    var topicId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = self.topViewController as? ShareBeautysetViewController{
            vc.topicId = topicId
        }
    }

}
