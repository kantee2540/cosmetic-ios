//
//  Network.swift
//  Cosmetic
//
//  Created by Omp on 19/3/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit
import AFNetworking

protocol NetworkDelegate {
    func downloadSuccess(data: Data)
    func downloadFailed(error: String)
}

class Network: NSObject {
    
    var delegate: NetworkDelegate?
    
    func downloadData(URL: String, param: [String: Any]){
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(URL, parameters: param, headers: nil, progress: {(Progress) in },
                     success: {(Operation, responseObject) in
                        self.delegate?.downloadSuccess(data: responseObject as! Data)
        },
                     failure: {(Operation, error) in
                        self.delegate?.downloadFailed(error: error.localizedDescription)
        })
        
    }
}
