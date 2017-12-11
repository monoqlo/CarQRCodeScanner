//
//  CarInspectionCertificateSharedItems.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/07/27.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

protocol CarInspectionCertificateGenerator {
    associatedtype QRCodeType: CarInspectionCertificateQRCode
    
    /**
     QRコードから読み取った文字列を元に CarInspectionCertificate を生成するイニシャライザ
     
     - parameter rawStrings: QRコードから読み取った文字列
     
     - returns: rawStrings の内容に不足がなければ生成された CarInspectionCertificate が返る
     */
    init?(rawStrings: [String])
    
    /**
     QRコードの値の配列を元に CarInspectionCertificate を生成するイニシャライザ
     
     - parameter qrCodes: QRコードの値の配列
     
     - returns: qrCodes の内容に不足がなければ生成された CarInspectionCertificate が返る
     */
    init?(qrCodes: [QRCodeType])
    
}

extension CarInspectionCertificateGenerator {
    
    init?(rawStrings: [String]) {
        var qrCodes: [QRCodeType] = []
        
        for rawString in rawStrings {
            guard let qrCode = QRCodeType(scanedString: rawString) else { return nil }
            qrCodes.append(qrCode)
        }
        
        self.init(qrCodes: qrCodes)
    }
    
}

/**
 *  車検証の共通項目
 *  （軽自動車および普通自動車のみ考慮）
 */
public protocol CarInspectionCertificateSharedItems {
    
    /// 車の種類
    var type: CarType { get }
    
    // MARK: - 車検証項目
    
    /// QRコードから読み取った文字列
    var rawStrings: [String] { get }
    
    /// 自動車登録番号又は車両番号
    var carNumber: String { get }
    
    /// 標板の枚数及び大きさ
    var numberPlateType: NumberPlateType? { get }
    
    /// 車台番号
    var carIdentifier: String { get }
    
    /// 原動機型式
    var engineType: String? { get }
    
    /// 帳票種別
    var sheetType: SheetType { get }
    
    /// 車台番号打刻位置
    var carIdentifierLocation: String? { get }
    
    /// 型式指定番号
    var carTypeNumber: String? { get }
    
    /// 類別区分番号
    var categoryNumber: String? { get }
    
    /// 有効期間満了日
    var expiration: Date? { get }
    
    /// 初年度登録年月
    var firstRegisteredYearMonth: Date? { get }
    
    /// 型式
    var carType: String { get }
    
    /// 軸重
    var axleWeight: AxleWeight { get }
    
    /// 騒音規制
    var noiseRegulation: NoiseRegulation? { get }
    
    /// 近接排気騒音規制値
    var closeEmissionNoiseRegulationValue: Int? { get }
    
    /// 駆動方式
    var driveSystem: DriveSystem? { get }
    
    /// オパシメータ測定車
    var measuredByOpacimeter: Bool? { get }
    
    /// NOx, PM測定モード
    var measurementModeForNOxAndPM: String? { get }
    
    /// NOx値
    var NOxValue: Int? { get }
    
    /// PM値
    var PMValue: Int? { get }

}

// MARK: -

public enum CarType: Int {
    case standard = 0
    case light = 1
}

protocol CarInspectionCertificateQRCode {
    var rawString: String { get }
    
    init?(scanedString: String)
}

/// 標板の枚数及び大きさ
public enum NumberPlateType: String {
    case One   = "1"
    case Two   = "2"
    case Three = "3"
    case Four  = "4"
    case Five  = "5"
    case Six   = "6"
    case Seven = "7"
    case Eight = "8"
    case A     = "A"
    case B     = "B"
    case C     = "C"
    case D     = "D"
    case E     = "E"
    case F     = "F"
    case G     = "G"
    case H     = "H"
    
    public var name: String {
        switch self {
        case .One, .A:
            return "小板・2枚・ペイント"
        case .Two, .B:
            return "大板・2枚・ペイント"
        case .Three, .C:
            return "小板・1枚・ペイント"
        case .Four, .D:
            return "大板・1枚・ペイント"
        case .Five, .E:
            return "小板・2枚・字光"
        case .Six, .F:
            return "大板・2枚・字光"
        case .Seven, .G:
            return "小板・1枚・字光"
        case .Eight, .H:
            return "大板・1枚・字光"
        }
    }
}

/**
 *  帳票種別
 */
public protocol SheetType {
    var name: String { get }
}

/**
 *  軸重
 */
public struct AxleWeight {
    public var frontFront: Int?
    public var frontRear: Int?
    public var rearFront: Int?
    public var rearRear: Int?
}

public enum NoiseRegulation: Int {
    case gs68 = 10
    case gs69 = 11
    case gs70 = 12
    case gs71 = 13
    
    public var name: String {
        let year: Int
        
        switch self {
        case .gs68:
            year = 10
        case .gs69:
            year = 11
        case .gs70:
            year = 12
        case .gs71: 
            year = 13
        }
        
        return "平成\(year)騒音規制車"
    }
}

/// 駆動方式
public enum DriveSystem: Int {
    case all   = 1
    case other = 2
    case none  = 0
    
    public var name: String {
        switch self {
        case .all:
            return "全輪駆動車"
        case .other:
            return "全輪駆動車以外"
        case .none:
            return "設定なし"
        }
    }
}
