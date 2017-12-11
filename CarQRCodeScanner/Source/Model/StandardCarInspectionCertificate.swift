//
//  StandardCarInspectionCertificate.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/07/28.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

/**
 *  普通自動車 車検証
 */
public struct StandardCarInspectionCertificate: CarInspectionCertificateSharedItems {
    typealias QRCodeType = StandardCarInspectionCertificateQRCode
    
    // MARK: - Original
    
    /// 保安基準適用年月日
    public var safetyStandardAppliedDate: Date?
    
    /// 燃料の種別
    public var fuelType: FuelType
    
    // MARK: - CarInspectionCertificate
    
    public let type: CarType = .standard
    
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

enum StandardCarInspectionCertificateQRCode: CarInspectionCertificateQRCode {
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
        
        if strings.count == 6 && StandardCarInspectionCertificateQRCode.validateTheFirstCodeOfCode2(scanedString) == true {
            self = .code2(strings)
        } else if strings.count == 19 && StandardCarInspectionCertificateQRCode.validateTheFirstCodeOfCode3(scanedString) == true {
            self = .code3(strings)
        } else {
            return nil
        }
    }
    
    static func validateTheFirstCodeOfCode2(_ text: String) -> Bool {
        let strings = text.components(separatedBy: "/")
        
        if strings.count < 2 {
            return false
        }
        
        // canBeConvertedToEncoding(NSASCIIStringEncoding)がtrueなら半角文字
        if strings[0] != "2" || strings[1].canBeConverted(to: String.Encoding.ascii) == true {
            return false
        }
        
        return true
    }
    
    static func validateTheFirstCodeOfCode3(_ text: String) -> Bool {
        let strings = text.components(separatedBy: "/")
        
        if strings.count < 5 {
            return false
        }
        
        if strings[0] != "2" ||
            strings[1].count != 3 ||
            strings[3].count != 6 ||
            strings[4].count != 4 {
            return false
        }
        
        return true
    }
}

/// 普通自動車 帳票種別
public enum StandardCarSheetType: Int, SheetType {
    case one   = 1
    case two   = 2
    case three = 3
    case four  = 4
    case five  = 5
    
    public var name: String {
        switch self {
        case .one:
            return "自動車検査証又は登録事項等通知書"
        case .two:
            return "一時抹消登録証明書又は登録識別情報等通知書"
        case .three:
            return "自動車予備検査証"
        case .four:
            return "自動車検査証返納証明書"
        case .five:
            return "限定自動車検査証"
        }
    }
}

/// 燃料の種別コード
public enum FuelType: String {
    case Gasoline = "01"
    case LightOil = "02"
    case LPG = "03"
    case HeatingOil = "04"
    case Electricity = "05"
    case GasolineAndLPG = "06"
    case GasolineAndHeatingOil = "07"
    case Methanol = "08"
    case CNG = "09"
    case LNG = "11"
    case ANG = "12"
    case CompressedHydrogen = "13"
    case GasolineAndElectricity = "14"
    case LPGAndElectricity = "15"
    case LightOilAndElectricity = "16"
    case Others = "99"
    case Unknown = "00"
    
    public var name: String {
        switch self {
        case .Gasoline:
            return "ガソリン"
        case .LightOil:
            return "軽油"
        case .LPG:
            return "LPG"
        case .HeatingOil:
            return "灯油"
        case .Electricity:
            return "電気"
        case .GasolineAndLPG:
            return "ガソリン・LPG"
        case .GasolineAndHeatingOil:
            return "ガソリン・灯油"
        case .Methanol:
            return "メタノール"
        case .CNG:
            return "CNG"
        case .LNG:
            return "LNG"
        case .ANG:
            return "ANG"
        case .CompressedHydrogen:
            return "圧縮水素"
        case .GasolineAndElectricity:
            return "ガソリン・電気"
        case .LPGAndElectricity:
            return "LPG・電気"
        case .LightOilAndElectricity:
            return "軽油・電気"
        case .Others:
            return "その他"
        case .Unknown:
            return "-"
        }
    }
}

// MARK: - CarInspectionCertificateGenerator
extension StandardCarInspectionCertificate: CarInspectionCertificateGenerator {
    
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
        carNumber = code2[1]
        
        if let numberPlateType = NumberPlateType(rawValue: code2[2]) {
            self.numberPlateType = numberPlateType
        }
        
        carIdentifier = code2[3]
        
        if code2[4] != "-" {
            engineType = code2[4]
        }
        
        guard let sheetTypeValue = Int(code2[5]), let sheetType = StandardCarSheetType(rawValue: sheetTypeValue) else { return nil }
        self.sheetType = sheetType
        
        
        // コード3
        //
        if code3[1] != "-  " {
            carIdentifierLocation = code3[1]
        }
        
        let carTypeNumberAndCategoryNumber = code3[2]
        if carTypeNumberAndCategoryNumber.count == 9 {
            // e.g. 123450234 => 12345, 0234
            carTypeNumber = String(carTypeNumberAndCategoryNumber.prefix(5))
            categoryNumber = String(carTypeNumberAndCategoryNumber.suffix(4))
        } else if carTypeNumberAndCategoryNumber.count == 10 && carTypeNumberAndCategoryNumber.hasPrefix("*") {
            // e.g. *123450234 => *12345, 0234
            carTypeNumber = String(carTypeNumberAndCategoryNumber.prefix(6))
            categoryNumber = String(carTypeNumberAndCategoryNumber.suffix(4))
        }
        
        // e.g. "080201"
        let expirationDateFormatter = DateFormatter()
        expirationDateFormatter.dateFormat = "yyMMdd"
        expirationDateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 9)
        if let expiration = expirationDateFormatter.date(from: code3[3]) {
            self.expiration = expiration
        }
        
        // e.g. "0802"
        let firstRegisteredYearMonthDateFormatter = DateFormatter()
        firstRegisteredYearMonthDateFormatter.dateFormat = "yyMM"
        firstRegisteredYearMonthDateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 9)
        if let firstRegisteredYearMonth = firstRegisteredYearMonthDateFormatter.date(from: code3[4]) {
            self.firstRegisteredYearMonth = firstRegisteredYearMonth
        }
        
        carType = code3[5]
        
        var axleWeight = AxleWeight()
        if let frontFrontValue = Int(code3[6]) {
            axleWeight.frontFront = frontFrontValue * 10
        }
        if let frontFrontValue = Int(code3[7]) {
            axleWeight.frontRear = frontFrontValue * 10
        }
        if let rearFrontValue = Int(code3[8]) {
            axleWeight.rearFront = rearFrontValue * 10
        }
        if let rearRearValue = Int(code3[9]) {
            axleWeight.rearRear = rearRearValue * 10
        }
        self.axleWeight = axleWeight
        
        if let noiseRegulationValue = Int(code3[10]),
            let noiseRegulation = NoiseRegulation(rawValue: noiseRegulationValue) {
            self.noiseRegulation = noiseRegulation
        }
        
        if let closeEmissionNoiseRegulationValue = Int(code3[11]) {
            self.closeEmissionNoiseRegulationValue = closeEmissionNoiseRegulationValue
        }
        
        if let driveSystemValue = Int(code3[12]),
            let driveSystem = DriveSystem(rawValue: driveSystemValue) {
            self.driveSystem = driveSystem
        }
        
        guard let measuredByOpacimeterValue = Int(code3[13]) else { return nil }
        if measuredByOpacimeterValue == 1 {
            measuredByOpacimeter = true
        } else if measuredByOpacimeterValue == 0 {
            measuredByOpacimeter = false
        } else {
            return nil
        }
        
        if code3[14] != "-" {
            measurementModeForNOxAndPM = code3[14]
        }
        
        if let NOxValue = Int(code3[15]) {
            self.NOxValue = NOxValue
        }
        
        if let PMValue = Int(code3[16]) {
            self.PMValue = PMValue
        }
        
        // e.g. "080201"
        let safetyStandardAppliedDateFormatter = DateFormatter()
        safetyStandardAppliedDateFormatter.dateFormat = "yyMMdd"
        safetyStandardAppliedDateFormatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * 9)
        if let safetyStandardAppliedDate = safetyStandardAppliedDateFormatter.date(from: code3[17]) {
            self.safetyStandardAppliedDate = safetyStandardAppliedDate
        }
        
        guard let fuelType = FuelType(rawValue: code3[18]) else { return nil }
        self.fuelType = fuelType
    }
    
}

extension StandardCarInspectionCertificate: CarInspectionCertificateItems {
    
    public var items: [CarInspectionCertificateItem] {
        get {
            var items = sharedItems
            
            let safetyStandardAppliedDateDescription: String?
            if let date = self.safetyStandardAppliedDate?.stringValue(format: "yy年M月d日") {
                safetyStandardAppliedDateDescription = "20" + date
            } else {
                safetyStandardAppliedDateDescription = nil
            }
            let safetyStandardAppliedDate = CarInspectionCertificateItem(title: "保安基準適用年月日", description: safetyStandardAppliedDateDescription)
            items.append(safetyStandardAppliedDate)
            
            let fuelType = CarInspectionCertificateItem(title: "燃料の種別", description: self.fuelType.name)
            items.append(fuelType)
            
            return items
        }
    }
    
}
