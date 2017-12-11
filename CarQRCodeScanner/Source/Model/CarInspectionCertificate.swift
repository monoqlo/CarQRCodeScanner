//
//  CarInspectionCertificate.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/15.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

public enum CarInspectionCertificate {
    case Standard(StandardCarInspectionCertificate)
    case Light(LightCarInspectionCertificate)
    
    public var standard: StandardCarInspectionCertificate? {
        get {
            switch self {
            case .Standard(let certificate):
                return certificate
            case .Light:
                return nil
            }
        }
    }
    
    public var light: LightCarInspectionCertificate? {
        get {
            switch self {
            case .Standard:
                return nil
            case .Light(let certificate):
                return certificate
            }
        }
    }
}