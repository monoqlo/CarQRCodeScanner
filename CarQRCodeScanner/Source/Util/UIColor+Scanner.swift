//
//  UIColor+Scanner.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/17.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct Scanner {
        static var mainTheme: UIColor { return #colorLiteral(red: 0.255, green: 0.600, blue: 0.565, alpha: 1.0) }
        static var mainThemeTransparent: UIColor { return #colorLiteral(red: 0.255, green: 0.600, blue: 0.565, alpha: 0.8) }
        static var mainErrorPurpleTransparent: UIColor { return #colorLiteral(red: 0.643, green: 0.153, blue: 0.435, alpha: 0.8) }
        static var progressBarNormalText: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8) }
        static var progressBarCompletedText: UIColor { return UIColor.white }
    }
    
}

