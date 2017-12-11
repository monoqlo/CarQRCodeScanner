//
//  CarInspectionCertificateItemViewCell.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/26.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

class CarInspectionCertificateItemCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    func configure(_ name: String, description: String?) {
        self.nameLabel.text = name
        self.descriptionLabel.text = description ?? "-"
    }

}
