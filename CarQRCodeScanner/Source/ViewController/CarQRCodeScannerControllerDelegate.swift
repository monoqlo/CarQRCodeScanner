//
//  CarInspectionCertificateQRScannerControllerDelegate.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/12.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

public protocol CarQRCodeScannerControllerDelegate: class {
    
    func qrScannerController(_ scanner: CarQRCodeScannerController, didFinishScanning certificate: CarInspectionCertificate) -> Void
    func qrScannerControllerDidCancel(_ scanner: CarQRCodeScannerController) -> Void
    
}
