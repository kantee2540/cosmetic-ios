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
    
    func saveTopic(topicId: String, userId: String){
        
        let DB_URL = getAddress.getInsertSaveTopicURL()
        let param = ["topic_id": topicId, "user_id": userId]
        
        let network = Network()
        network.delegate = self
        network.downloadData(URL: DB_URL, param: param)
    }
        
    
}
