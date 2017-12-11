//
//  ScanStatusView.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/17.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

enum ScanStatus {
    case neutral
    case success(message: String)
    case failure(message: String)
    
    var message: String {
        switch self {
        case .neutral:
            return ""
        case .success(let message):
            return message
        case .failure(let message):
            return message
        }
    }
    
    var color: UIColor {
        switch self {
        case .neutral:
            return UIColor.clear
        case .success:
            return UIColor.Scanner.mainThemeTransparent
        case .failure:
            return UIColor.Scanner.mainErrorPurpleTransparent
        }
    }
}

class ScanStatusView: UIView, PopUp {
    
    var status: ScanStatus = .neutral {
        didSet {
            backgroundColor = status.color
            messageLabel.text = status.message
        }
    }
    
    var messageFont: UIFont {
        get {
            return messageLabel.font
        }
        
        set {
            messageLabel.font = newValue
        }
    }
    
    fileprivate var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    fileprivate func setup() {
        addSubview(messageLabel)

        let margins = layoutMarginsGuide
        messageLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
    }
    
    
}
