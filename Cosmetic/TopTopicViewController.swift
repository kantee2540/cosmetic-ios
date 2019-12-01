//
//  TopTopicViewController.swift
//  Cosmetic
//
//  Created by Omp on 29/11/2562 BE.
//  Copyright © 2562 Omp. All rights reserved.
//

import UIKit

class TopTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DownloadTopicProtocol {
    func topicDownloaded(item: NSMutableArray) {
        
    }
    
    
    var topicId: String!
    
    @IBOutlet weak var mainTable: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contentCell = tableView.dequeueReusableCell(withIdentifier: "Content")!
        contentCell.selectionStyle = .none
            
        return contentCell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        
        downloadPackage()
    }
    
    private func downloadPackage(){
        let downloadPackage = DownloadPackage()
        downloadPackage.delegate = self as? DownloadPackageProtocol
        //downloadPackage.downloadByTopicId(id: topicId)
    }
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
