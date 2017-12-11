//
//  CarInspectionCertificateTableViewController.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/01.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit
import CarQRCodeScanner

class CarInspectionCertificateTableViewController: UITableViewController {
    
    var certificate: CarInspectionCertificateItems!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 61
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.certificate.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarInspectionCertificateItemCell", for: indexPath) as! CarInspectionCertificateItemCell
        
        let item = self.certificate.items[indexPath.row]
        cell.configure(item.title, description: item.description)
        
        return cell
    }
}
