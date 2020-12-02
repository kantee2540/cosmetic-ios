//
//  SaveTopic.swift
//  Cosmetic
//
//  Created by Omp on 15/4/2563 BE.
//  Copyright © 2563 Omp. All rights reserved.
//

import UIKit

protocol SaveTopicDelegate {
    func saveTopicSuccess()
    func saveTopicFailed()
}

class SaveTopic: NSObject, NetworkDelegate {
    func downloadSuccess(data: Data) {
        delegate?.saveTopicSuccess()
    }
    
    func downloadFailed(error: String) {
        delegate?.saveTopicFailed()
    }
    
    var delegate: SaveTopicDelegate?
    
    let getAddress = webAddress()
    var DB_URL: String?
    
    func saveTopic(topicId: Int, userId: Int){
        
        let DB_URL = getAddress.getInsertSaveTopicURL()
        let param = ["topic_id": topicId, "user_id": userId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["":""])
    }
        
    func deleteTopic(topicId: Int, userId: Int){
        let DB_URL = getAddress.getDeleteSaveTopicURL()
        let param = ["topic_id": topicId, "user_id": userId]
        
        let network = Network()
        network.delegate = self
        network.post(URL: DB_URL, param: param, header: ["":""])
    }
}
