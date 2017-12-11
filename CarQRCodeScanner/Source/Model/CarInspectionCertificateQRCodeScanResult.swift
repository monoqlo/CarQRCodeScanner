//
//  CarInspectionCertificateQRCodeScanResult.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/01.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

protocol CarInspectionCertificateQRCodeScanResult {
    associatedtype QRCodeType: CarInspectionCertificateQRCode
    
    var requiredCounts: Int { get }
    var qrCodes: [QRCodeType] { get }
    var progress: Double { get }
    var completed: Bool { get }
    
}

extension CarInspectionCertificateQRCodeScanResult {
    
    var completed: Bool {
        get {
            if qrCodes.count == requiredCounts {
                return true
            } else {
                return false
            }
        }
    }
    
}

struct LightCarScanResult: CarInspectionCertificateQRCodeScanResult {
    typealias QRCodeType = LightCarInspectionCertificateQRCode
    
    let requiredCounts: Int = 2
    
    var qrCodes: [QRCodeType] {
        get {
            var qrCodes: [QRCodeType] = []
            
            if let qrCode = qrCode2 {
                qrCodes.append(qrCode)
            }
            if let qrCode = qrCode3 {
                qrCodes.append(qrCode)
            }
            
            return qrCodes
        }
    }
    
    var progress: Double {
        get {
            return Double(qrCodes.count) / Double(requiredCounts)
        }
    }
    
    var qrCode2: QRCodeType?
    var qrCode3: QRCodeType?
}

struct StandardCarScanResult: CarInspectionCertificateQRCodeScanResult {
    typealias QRCodeType = StandardCarInspectionCertificateQRCode
    
    let requiredCounts: Int = 2
    
    var qrCodes: [QRCodeType] {
        get {
            var qrCodes: [QRCodeType] = []
            
            if let qrCode = qrCode2 {
                qrCodes.append(qrCode)
            }
            if let qrCode = qrCode3 {
                qrCodes.append(qrCode)
            }
            
            return qrCodes
        }
    }
    
    var progress: Double {
        get {
            return Double(storedValueCount) / Double(requiredValueCount)
        }
    }
    
    var qrCode2: QRCodeType?
    var qrCode3: QRCodeType?
    
    var qrCode2Parity: Int?
    var qrCode3Parity: Int?
    
    var qrCode2_1Value: String? {
        didSet {
            generateQRCode2FromStoredValues()
        }
    }
    
    var qrCode2_2Value: String? {
        didSet {
            generateQRCode2FromStoredValues()
        }
    }
    
    var qrCode3_1Value: String? {
        didSet {
            generateQRCode3FromStoredValues()
        }
    }
    
    var qrCode3_2Value: String? {
        didSet {
            generateQRCode3FromStoredValues()
        }
    }
    
    var qrCode3_3Value: String? {
        didSet {
            generateQRCode3FromStoredValues()
        }
    }
    
    fileprivate var requiredValueCount = 5
    
    fileprivate var storedValueCount: Int {
        get {
            var count = 0
            
            if let _ = qrCode2_1Value { count += 1 }
            if let _ = qrCode2_2Value { count += 1 }
            if let _ = qrCode3_1Value { count += 1 }
            if let _ = qrCode3_2Value { count += 1 }
            if let _ = qrCode3_3Value { count += 1 }
            
            return count
        }
    }
    
    fileprivate mutating func generateQRCode2FromStoredValues() {
        if let qrCode2_1 = qrCode2_1Value,
            let qrCode2_2 = qrCode2_2Value {
            qrCode2 = StandardCarInspectionCertificateQRCode(scanedString: qrCode2_1 + qrCode2_2)
        }
    }
    
    fileprivate mutating func generateQRCode3FromStoredValues() {
        if let qrCode3_1 = qrCode3_1Value,
            let qrCode3_2 = qrCode3_2Value,
            let qrCode3_3 = qrCode3_3Value {
            qrCode3 = StandardCarInspectionCertificateQRCode(scanedString: qrCode3_1 + qrCode3_2 + qrCode3_3)
        }
    }
}
