//
//  CarInspectionCertificateItem.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/02.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation

public struct CarInspectionCertificateItem {
    public let title: String
    public let description: String?
}

public protocol CarInspectionCertificateItems {
    var items: [CarInspectionCertificateItem] { get }
}

extension CarInspectionCertificateSharedItems {
    var sharedItems: [CarInspectionCertificateItem] {
        get {
            var items: [CarInspectionCertificateItem] = []
            
            let carNumber = CarInspectionCertificateItem(title: "自動車登録番号又は車両番号", description: self.carNumber)
            items.append(carNumber)
            
            let numberPlateType = CarInspectionCertificateItem(title: "標板の枚数及び大きさ", description: self.numberPlateType?.name)
            items.append(numberPlateType)
            
            let carIdentifier = CarInspectionCertificateItem(title: "車台番号", description: self.carIdentifier)
            items.append(carIdentifier)
            
            let engineType = CarInspectionCertificateItem(title: "原動機型式", description: self.engineType)
            items.append(engineType)
            
            let sheetType = CarInspectionCertificateItem(title: "帳票種別", description: self.sheetType.name)
            items.append(sheetType)
            
            let carIdentifierLocation = CarInspectionCertificateItem(title: "車台番号打刻位置", description: self.carIdentifierLocation)
            items.append(carIdentifierLocation)
            
            let carTypeNumber = CarInspectionCertificateItem(title: "型式指定番号", description: self.carTypeNumber)
            items.append(carTypeNumber)
            
            let categoryNumber = CarInspectionCertificateItem(title: "類別区分番号", description: self.categoryNumber)
            items.append(categoryNumber)
            
            let expirationDescription: String?
            if let date = self.expiration?.stringValue(format: "yy年M月d日") {
                expirationDescription = "20" + date
            } else {
                expirationDescription = nil
            }
            let expiration = CarInspectionCertificateItem(title: "有効期間満了日", description: expirationDescription)
            items.append(expiration)
            
            let firstRegisteredYearMonthDescription: String?
            if let date = self.firstRegisteredYearMonth?.stringValue(format: "yy年M月") {
                firstRegisteredYearMonthDescription = "20" + date
            } else {
                firstRegisteredYearMonthDescription = nil
            }
            let firstRegisteredYearMonth = CarInspectionCertificateItem(title: "初年度登録年月", description: firstRegisteredYearMonthDescription)
            items.append(firstRegisteredYearMonth)
            
            let carType = CarInspectionCertificateItem(title: "型式", description: self.carType)
            items.append(carType)
            
            let frontFrontValue: String?
            if let frontFront = self.axleWeight.frontFront {
                frontFrontValue = String(frontFront) + "kg"
            } else {
                frontFrontValue = nil
            }
            let axleWeightFrontFront = CarInspectionCertificateItem(title: "軸重（前前）", description: frontFrontValue)
            items.append(axleWeightFrontFront)
            
            let frontRearValue: String?
            if let frontRear = self.axleWeight.frontRear {
                frontRearValue = String(frontRear) + "kg"
            } else {
                frontRearValue = nil
            }
            let axleWeightFrontRear = CarInspectionCertificateItem(title: "軸重（前後）", description: frontRearValue)
            items.append(axleWeightFrontRear)
            
            let rearFrontValue: String?
            if let rearFront = self.axleWeight.rearFront {
                rearFrontValue = String(rearFront) + "kg"
            } else {
                rearFrontValue = nil
            }
            let axleWeightRearFront = CarInspectionCertificateItem(title: "軸重（後前）", description: rearFrontValue)
            items.append(axleWeightRearFront)
            
            let rearRearValue: String?
            if let rearRear = self.axleWeight.rearRear {
                rearRearValue = String(rearRear) + "kg"
            } else {
                rearRearValue = nil
            }
            let axleWeightRearRear = CarInspectionCertificateItem(title: "軸重（後後）", description: rearRearValue)
            items.append(axleWeightRearRear)
            
            let noiseRegulation = CarInspectionCertificateItem(title: "騒音規制", description: self.noiseRegulation?.name)
            items.append(noiseRegulation)
            
            let closeEmissionNoiseRegulationValueString: String?
            if let value = self.closeEmissionNoiseRegulationValue {
                closeEmissionNoiseRegulationValueString = String(value) + "dB"
            } else {
                closeEmissionNoiseRegulationValueString = nil
            }
            let closeEmissionNoiseRegulationValue = CarInspectionCertificateItem(title: "近接排気騒音規制値", description: closeEmissionNoiseRegulationValueString)
            items.append(closeEmissionNoiseRegulationValue)
            
            let driveSystem = CarInspectionCertificateItem(title: "駆動方式", description: self.driveSystem?.name)
            items.append(driveSystem)
            
            let measuredByOpacimeterString: String?
            if let value = self.measuredByOpacimeter, value == true {
                measuredByOpacimeterString = "オパシメータ測定"
            } else {
                measuredByOpacimeterString = nil
            }
            let measuredByOpacimeter = CarInspectionCertificateItem(title: "オパシメータ測定車", description: measuredByOpacimeterString)
            items.append(measuredByOpacimeter)
            
            let measurementModeForNOxAndPM = CarInspectionCertificateItem(title: "NOx, PM測定モード", description: self.measurementModeForNOxAndPM)
            items.append(measurementModeForNOxAndPM)
            
            let NOxValueString: String?
            if let NOxValue = self.NOxValue {
                NOxValueString = String(NOxValue)
            } else {
                NOxValueString = nil
            }
            let NOxValue = CarInspectionCertificateItem(title: "NOx値", description: NOxValueString)
            items.append(NOxValue)
            
            let PMValueString: String?
            if let PMValue = self.PMValue {
                PMValueString = String(PMValue)
            } else {
                PMValueString = nil
            }
            let PMValue = CarInspectionCertificateItem(title: "PM値", description: PMValueString)
            items.append(PMValue)
            
            
            return items
        }
    }
    
}
