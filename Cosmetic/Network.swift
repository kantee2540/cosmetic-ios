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
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        manager.post(URL, parameters: param, success: {
            (operation: AFHTTPRequestOperation, responseObject: Any) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.downloadSuccess(data: responseObject as! Data)
            })
        }, failure: {
            (opefation: AFHTTPRequestOperation?, error: Error) in
            print(error)
            DispatchQueue.main.async(execute: { () -> Void in
                self.delegate?.downloadFailed(error: error.localizedDescription)
            })
        })
    }
}
