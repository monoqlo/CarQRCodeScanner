//
//  LightCarInspectionCertificate.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/07/28.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

/**
 *  軽自動車 車検証
 */
public struct LightCarInspectionCertificate: CarInspectionCertificateSharedItems {
    typealias QRCodeType = LightCarInspectionCertificateQRCode
    
    // MARK: - Original
    
    /// 予備項目
    public var extraValue: String
    
    // MARK: - CarInspectionCertificate
    
    public let type: CarType = .light
    
    public var rawStrings: [String]
    public var carNumber: String
    public var numberPlateType: NumberPlateType?
    public var carIdentifier: String
    public var engineType: String?
    public var sheetType: SheetType
    public var carIdentifierLocation: String?
    public var carTypeNumber: String?
    public var categoryNumber: String?
    public var expiration: Date?
    public var firstRegisteredYearMonth: Date?
    public var carType: String
    public var axleWeight: AxleWeight
    public var noiseRegulation: NoiseRegulation?
    public var closeEmissionNoiseRegulationValue: Int?
    public var driveSystem: DriveSystem?
    public var measuredByOpacimeter: Bool?
    public var measurementModeForNOxAndPM: String?
    public var NOxValue: Int?
    public var PMValue: Int?
    
}

enum LightCarInspectionCertificateQRCode: CarInspectionCertificateQRCode {
    case code2([String])
    case code3([String])
    
    var rawString: String {
        func joinStringsWithSeparater(_ strings: [String]) -> String {
            return strings.reduce("", { (str1, str2) -> String in
                if str1 == "" {
                    return str1 + str2
                } else {
                    return str1 + "/" + str2
                }
            })
        }
        
        switch self {
        case .code2(let value):
            return joinStringsWithSeparater(value)
        case .code3(let value):
            return joinStringsWithSeparater(value)
        }
    }
    
    init?(scanedString: String) {
        let strings = scanedString.components(separatedBy: "/")
        
        // バージョン番号を固定せず、現状の最新版以上でバリデーションをかけている。不都合があれば固定すること
        if strings.count == 7 {
            guard let code2Version = Int(strings[1]), strings[0] == "K" && code2Version >= 22 else { return nil }
            self = .code2(strings)
        } else if strings.count == 19 {
            guard let code3Version = Int(strings[1]), strings[0] == "K" && code3Version >= 31 else { return nil }
            self = .code3(strings)
        } else {
            return nil
        }
    }
}

/// 軽自動車 帳票種別
public enum LightCarSheetType: Int, SheetType {
    case one   = 1
    case two   = 2
    case three = 3
    case four  = 4
    
    public var name: String {
        switch self {
        case .one:
            return "自動車検査証"
        case .two:
            return "自動車予備検査証"
        case .three:
            return "限定自動車検査証（その１）"
        case .four:
            return "自動車検査証返納証明書"
        }
    }
}

// MARK: - CarInspectionCertificateGenerator
extension LightCarInspectionCertificate: CarInspectionCertificateGenerator {
    
    init?(qrCodes: [QRCodeType]) {
        
        if qrCodes.count < 2 {
            return nil
        }
        
        var qrCode2Value: [String]?
        var qrCode3Value: [String]?
        
        rawStrings = []
        
        for qrCode in qrCodes {
            switch qrCode {
            case .code2(let value):
                qrCode2Value = value
            case .code3(let value):
                qrCode3Value = value
            }
            
            rawStrings.append(qrCode.rawString)
        }
        
        guard let code2 = qrCode2Value else { return nil }
        guard let code3 = qrCode3Value else { return nil }
        
        // コード2
        //
        carNumber = code2[2]
        
        if let numberPlateType = NumberPlateType(rawValue: code2[3]) {
            self.numberPlateType = numberPlateType
        }
        
        carIdentifier = code2[4]
        
        if code2[5] != "-" {
            engineType = code2[5]
        }
        
        guard let sheetTypeValue = Int(code2[6]), let sheetType = StandardCarSheetType(rawValue: sheetTypeValue) else { return nil }
        self.sheetType = sheetType
        
        // コード3
        //
        if code3[2] != "-  " {
            carIdentifierLocation = code3[2]
        }
        
        let carTypeNumberAndCategoryNumber = code3[3]
        if carTypeNumberAndCategoryNumber.count == 9 {
            // e.g. 123450234 => 12345, 0234
            carTypeNumber = String(carTypeNumberAndCategoryNumber.prefix(5))
            categoryNumber = String(carTypeNumberAndCategoryNumber.suffix(4))
        }
        
        // e.g. "080201"
        let expirationDateFormatter = DateFormatter()
        expirationDateFormatter.dateFormat = "yyMMdd"
        expirationDateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 9)
        if let expiration = expirationDateFormatter.date(from: code3[4]) {
            self.expiration = expiration
        }
        
        // e.g. "0802"
        let firstRegisteredYearMonthDateFormatter = DateFormatter()
        firstRegisteredYearMonthDateFormatter.dateFormat = "yyMM"
        firstRegisteredYearMonthDateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 9)
        if let firstRegisteredYearMonth = firstRegisteredYearMonthDateFormatter.date(from: code3[5]) {
            self.firstRegisteredYearMonth = firstRegisteredYearMonth
        }
        
        carType = code3[6]
        
        var axleWeight = AxleWeight()
        if let frontFrontValue = Int(code3[7]) {
            axleWeight.frontFront = frontFrontValue * 10
        }
        if let frontFrontValue = Int(code3[8]) {
            axleWeight.frontRear = frontFrontValue * 10
        }
        if let rearFrontValue = Int(code3[9]) {
            axleWeight.rearFront = rearFrontValue * 10
        }
        if let rearRearValue = Int(code3[10]) {
            axleWeight.rearRear = rearRearValue * 10
        }
        self.axleWeight = axleWeight
        
        if let noiseRegulationValue = Int(code3[11]),
            let noiseRegulation = NoiseRegulation(rawValue: noiseRegulationValue) {
            self.noiseRegulation = noiseRegulation
        }
        
        if let closeEmissionNoiseRegulationValue = Int(code3[12]) {
            self.closeEmissionNoiseRegulationValue = closeEmissionNoiseRegulationValue
        }
        
        if let driveSystemValue = Int(code3[13]),
            let driveSystem = DriveSystem(rawValue: driveSystemValue) {
            self.driveSystem = driveSystem
        }
        
        if let measuredByOpacimeterValue = Int(code3[14]) {
            if measuredByOpacimeterValue == 1 {
                measuredByOpacimeter = true
            } else if measuredByOpacimeterValue == 0 {
                measuredByOpacimeter = false
            }
        }
        
        if code3[15] != "-" {
            measurementModeForNOxAndPM = code3[15]
        }
        
        if let NOxValue = Int(code3[16]) {
            self.NOxValue = NOxValue
        }
        
        if let PMValue = Int(code3[17]) {
            self.PMValue = PMValue
        }
        
        extraValue = code3[18]
    }
    
}

extension LightCarInspectionCertificate: CarInspectionCertificateItems {
    
    public var items: [CarInspectionCertificateItem] {
        get {
            var items = sharedItems
            
            let extraValue = CarInspectionCertificateItem(title: "予備項目", description: self.extraValue)
            items.append(extraValue)
            
            return items
        }
    }
    
}
