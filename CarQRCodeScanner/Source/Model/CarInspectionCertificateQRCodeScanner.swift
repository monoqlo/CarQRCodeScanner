//
//  CarInspectionCertificateQRCodeValidator.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/16.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import Foundation
import ZXingObjC

protocol CarInspectionCertificateQRCodeScannerDelegate: class {
    func scanner(_ scanner: CarInspectionCertificateQRCodeScanner, didValidate result: CarInspectionCertificateQRCodeValidatationResult)
    func scanner(_ scanner: CarInspectionCertificateQRCodeScanner, didComplete certificate: CarInspectionCertificate)
}

enum CarInspectionCertificateQRCodeValidatationResult {
    case success(type: CarType, progress: Double)
    case failure(reason: CarInspectionCertificateQRCodeValidatationFailureReason)
}

enum CarInspectionCertificateQRCodeValidatationFailureReason {
    case unknownError
    case noCarInspectionCertificate
    case needToScanTheFirstCode
    case differentStandardCarInspectionCertificate
    case duplicated
    
    var description: String {
        switch self {
        case .unknownError:
            return "読み取りに失敗しました。もう1度お試し下さい。"
        case .noCarInspectionCertificate:
            return "このQRコードは読み取る必要がありません。"
        case .needToScanTheFirstCode:
            return "このQRコードは分割されたQRコードの一部です。まずは左側1つ目のQRコードを読み取ってください。"
        case .differentStandardCarInspectionCertificate:
            return "別の車検証を読み取るには1度キャンセルしてください。"
        case .duplicated:
            return "このQRコードはすでに読み取り済みです。"
        }
    }
}

class CarInspectionCertificateQRCodeScanner: NSObject {
    
    weak var delegate: CarInspectionCertificateQRCodeScannerDelegate? {
        didSet {
            if let _ = delegate {
                capture.delegate = self
            } else {
                capture.delegate = nil
            }
        }
    }
    
    fileprivate var detectedCarType: CarType?
    fileprivate var certificate: CarInspectionCertificate?
    fileprivate var lastScannedText: String = ""
    fileprivate var scannedTexts: Set<String> = []
    fileprivate var lightCarResult: LightCarScanResult = LightCarScanResult()
    fileprivate var standardCarResult: StandardCarScanResult = StandardCarScanResult()
    
    fileprivate(set) var capture: ZXCapture = {
        let capture = ZXCapture()
        capture.sessionPreset = AVCaptureSession.Preset.hd1920x1080.rawValue
        capture.camera = capture.back()
        capture.focusMode = .continuousAutoFocus
        return capture
    }()
    
    func stop() {
        capture.delegate = nil
        capture.stop()
    }
    
    func reset() {
        detectedCarType = nil
        certificate = nil
        scannedTexts = []
        lightCarResult = LightCarScanResult()
        standardCarResult = StandardCarScanResult()
        
        if capture.running == false {
            capture.start()
        }
    }
    
}


// MARK: - ZXCaptureDelegate
extension CarInspectionCertificateQRCodeScanner: ZXCaptureDelegate {
    
    @objc func captureResult(_ capture: ZXCapture!, result: ZXResult!) {
        guard let _ = result else { return }
        
        if let _ = certificate {
            return
        }
        
        guard let result = validate(scanResult: result) else { return }
        delegate?.scanner(self, didValidate: result)
        
        if case .success = result {
            delegateCertificateIfScanCompleted()
        }
    }
    
    // MARK: -
    
    fileprivate func validate(scanResult result: ZXResult) -> CarInspectionCertificateQRCodeValidatationResult? {
        guard let text = result.text else { return .failure(reason: .unknownError)}
        
        if text == lastScannedText {
            return nil
        }
        
        lastScannedText = text
        
        let validationResult: CarInspectionCertificateQRCodeValidatationResult
        
        if scannedTexts.contains(text) {
            validationResult = .failure(reason: .duplicated)
        } else if let carType = detectedCarType {
            switch carType {
            case .standard:
                validationResult = validateStandardCarScanResult(result)
            case .light:
                validationResult = validateLightCarScanResult(text: text)
            }
        } else {
            let standardCarScanResult = validateStandardCarScanResult(result)
            let lightCarScanResult = validateLightCarScanResult(text: text)
            
            if case .failure = standardCarScanResult, case .failure = lightCarScanResult {
                validationResult = standardCarScanResult
            } else if case .success = standardCarScanResult {
                detectedCarType = .standard
                validationResult = standardCarScanResult
            } else if case .success = lightCarScanResult {
                detectedCarType = .light
                validationResult = lightCarScanResult
            } else {
                validationResult = .failure(reason: .unknownError)
            }
        }
        
        if case .failure(let reason) = validationResult, reason != .needToScanTheFirstCode {
            scannedTexts.insert(text)
        }
        
        return validationResult
    }
    
    fileprivate func delegateCertificateIfScanCompleted() {
        if let carType = detectedCarType, checkScanCompletion(carType) == true {
            switch carType {
            case .standard:
                guard let certificate = StandardCarInspectionCertificate(qrCodes: standardCarResult.qrCodes) else { return }
                self.certificate = CarInspectionCertificate.Standard(certificate)
                
            case .light:
                guard let certificate = LightCarInspectionCertificate(qrCodes: lightCarResult.qrCodes) else { return }
                self.certificate = CarInspectionCertificate.Light(certificate)
            }
            
            delegate?.scanner(self, didComplete: certificate!)
        }
    }
    
    fileprivate func checkScanCompletion(_ carType: CarType) -> Bool {
        switch carType {
        case .standard:
            if standardCarResult.completed == true {
                capture.stop()
                
                guard let _ = StandardCarInspectionCertificate(qrCodes: standardCarResult.qrCodes) else {
                    reset()
                    return false
                }
            } else {
                return false
            }
            
        case .light:
            if lightCarResult.completed == true {
                capture.stop()
                
                guard let _ = LightCarInspectionCertificate(qrCodes: lightCarResult.qrCodes) else {
                    reset()
                    return false
                }
            } else {
                return false
            }
        }
        
        return true
    }
    
    fileprivate func validateStandardCarScanResult(_ result: ZXResult) -> CarInspectionCertificateQRCodeValidatationResult {
        // 分割QRコードの場合、resultMetadata の以下2つを確認してどの部分のQRコードが読み込まれたのか判定することができる
        // - kResultMetadataTypeStructuredAppendSequence
        // - kResultMetadataTypeStructuredAppendParity
        
        guard let metaData = result.resultMetadata,
            let sequenceValue = metaData[Int(kResultMetadataTypeStructuredAppendSequence.rawValue)] as? Int,
            let parity = metaData[Int(kResultMetadataTypeStructuredAppendParity.rawValue)] as? Int else { return .failure(reason: .noCarInspectionCertificate)}
        
        // sequence: 読み取ったQRコードの番号 4bit + トータルのQRコード数 4bit
        
        let bit = String(sequenceValue, radix: 2)
        let pad = String(repeating: "0", count: (8 - bit.count))
        let sequence = pad + bit
        let current = String(sequence.prefix(4))
        let total = String(sequence[sequence.index(sequence.startIndex, offsetBy: 4)...])
        
        let position = Int(current, radix: 2)! + 1
        let totalPosition = Int(total, radix: 2)! + 1
        
        return validateStandardCarScanResult(text: result.text, position: position, totalPosition: totalPosition, parity: parity)
    }
    
    fileprivate func validateStandardCarScanResult(text: String, position: Int, totalPosition: Int, parity: Int) -> CarInspectionCertificateQRCodeValidatationResult {
        if totalPosition == 2 {
            if let qrCode2Parity = standardCarResult.qrCode2Parity {
                if parity != qrCode2Parity {
                    return .failure(reason: .differentStandardCarInspectionCertificate)
                }
            } else {
                if position != 1 {
                    return .failure(reason: .needToScanTheFirstCode)
                }
            }
            
            if position == 1 {
                if let _ = standardCarResult.qrCode2_1Value {
                    return .failure(reason: .duplicated)
                }
                
                if StandardCarInspectionCertificateQRCode.validateTheFirstCodeOfCode2(text) == false {
                    return .failure(reason: .noCarInspectionCertificate)
                }
                
                standardCarResult.qrCode2Parity = parity
                standardCarResult.qrCode2_1Value = text
            } else if position == 2 {
                if let _ = standardCarResult.qrCode2_2Value {
                    return .failure(reason: .duplicated)
                }
                
                standardCarResult.qrCode2_2Value = text
            }
        } else if totalPosition == 3 {
            if let qrCode3Parity = standardCarResult.qrCode3Parity {
                if parity != qrCode3Parity {
                    return .failure(reason: .differentStandardCarInspectionCertificate)
                }
            } else {
                if position != 1 {
                    return .failure(reason: .needToScanTheFirstCode)
                }
            }
            
            if position == 1 {
                if let _ = standardCarResult.qrCode3_1Value {
                    return .failure(reason: .duplicated)
                }
                
                if StandardCarInspectionCertificateQRCode.validateTheFirstCodeOfCode3(text) == false {
                    return .failure(reason: .noCarInspectionCertificate)
                }
                
                standardCarResult.qrCode3Parity = parity
                standardCarResult.qrCode3_1Value = text
            } else if position == 2 {
                if let _ = standardCarResult.qrCode3_2Value {
                    return .failure(reason: .duplicated)
                }
                
                standardCarResult.qrCode3_2Value = text
            } else if position == 3 {
                if let _ = standardCarResult.qrCode3_3Value {
                    return .failure(reason: .duplicated)
                }
                
                standardCarResult.qrCode3_3Value = text
            }
        } else {
            return .failure(reason: .noCarInspectionCertificate)
        }
        
        Vibrator.vibrate()
        
        return .success(type: .standard, progress: standardCarResult.progress)
    }
    
    fileprivate func validateLightCarScanResult(text: String) -> CarInspectionCertificateQRCodeValidatationResult {
        guard let qrCode = LightCarInspectionCertificateQRCode(scanedString: text) else { return .failure(reason: .noCarInspectionCertificate) }
        
        switch qrCode {
        case .code2:
            if let _ = lightCarResult.qrCode2 {
                return .failure(reason: .duplicated)
            }
            
            lightCarResult.qrCode2 = qrCode
        case .code3:
            if let _ = lightCarResult.qrCode3 {
                return .failure(reason: .duplicated)
            }
            
            lightCarResult.qrCode3 = qrCode
        }
        
        Vibrator.vibrate()
        
        return .success(type: .light, progress: lightCarResult.progress)
    }
    
}
