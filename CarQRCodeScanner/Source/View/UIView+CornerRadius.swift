//
//  UIView+CornerRadius.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/16.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
