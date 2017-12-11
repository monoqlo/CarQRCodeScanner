//
//  NSDateUtil.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/02.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

extension Date {
    func stringValue(format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
