//
//  CarInspectionCertificateQRScannerController.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/12.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit
import ZXingObjC

/// このクラスは `CarQRCodeScannerController` 経由で使うこと
class CarQRCodeScannerViewController: UIViewController {
    
    weak var delegate: CarQRCodeScannerControllerDelegate?
    
    fileprivate var scanner = CarInspectionCertificateQRCodeScanner()
    
    fileprivate var scannerController: CarQRCodeScannerController {
        get {
            return navigationController! as! CarQRCodeScannerController
        }
    }
    
    @IBOutlet fileprivate weak var qrFrameView: UIImageView!
    @IBOutlet fileprivate weak var previewView: UIView!
    
    @IBOutlet fileprivate weak var checkmark: ScanCheckmarkView!
    @IBOutlet fileprivate weak var successfulView: UIView!
    @IBOutlet fileprivate weak var statusView: ScanStatusView!
    @IBOutlet fileprivate weak var progressView: ScanProgressView!
    
    // MARK: - Initializer
    
    class func instantiateFromStoryboard() -> CarQRCodeScannerViewController {
        let bundle = Bundle(for: CarQRCodeScannerViewController.self)
        let viewController = UIStoryboard(name: "Scanner", bundle: bundle).instantiateViewController(withIdentifier: "CarInspectionCertificateQRScannerViewController") as! CarQRCodeScannerViewController
        return viewController
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCancelButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reset()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanner.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        scanner.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layoutIfNeeded()
        
        scanner.capture.layer.frame = previewView.frame
        applyOrientation()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.applyOrientation()
        }
    }
    
    // MARK: -
    fileprivate func setCancelButton() {
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc fileprivate func cancel() {
        stop()
        dismiss(animated: true) {
            self.delegate?.qrScannerControllerDidCancel(self.scannerController)
        }
    }
    
    fileprivate func stop() {
        scanner.capture.layer.removeFromSuperlayer()
        scanner.stop()
    }
    
    fileprivate func reset() {
        scanner.reset()
        checkmark.isHidden = true
        successfulView.isHidden = true
        statusView.status = .neutral
        progressView.progress = 0
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        if scanner.capture.layer.superlayer == nil {
            previewView.layer.addSublayer(scanner.capture.layer)
        }
    }
    
    fileprivate func applyOrientation() {
        let orientation = UIApplication.shared.statusBarOrientation
        let scanRectRotation: CGFloat
        let captureRotation: CGFloat
        
        switch orientation {
        case .portrait, .unknown:
            captureRotation = 0
            scanRectRotation = 90
            
        case .landscapeLeft:
            captureRotation = 90
            scanRectRotation = 180
            
        case .landscapeRight:
            captureRotation = 270
            scanRectRotation = 0
            
        case .portraitUpsideDown:
            captureRotation = 180
            scanRectRotation = 270
        }
        
        applyRectOfInterest(orientation: orientation)
        
        let transform = CGAffineTransform(rotationAngle: captureRotation / 180 * CGFloat(Double.pi))
        scanner.capture.transform = transform
        scanner.capture.rotation = scanRectRotation
        scanner.capture.layer.frame = previewView.frame
    }
    
    fileprivate func applyRectOfInterest(orientation: UIInterfaceOrientation) {
        let scaleVideo, scaleVideoX, scaleVideoY: CGFloat
        let videoSizeX, videoSizeY: CGFloat
        var transformedVideoRect = qrFrameView.convert(qrFrameView.bounds, to: previewView)
        
        if scanner.capture.sessionPreset == AVCaptureSession.Preset.hd1920x1080.rawValue {
            videoSizeX = 1080
            videoSizeY = 1920
        } else {
            videoSizeX = 720
            videoSizeY = 1280
        }
        
        if orientation.isPortrait == true {
            scaleVideoX = previewView.frame.size.width / videoSizeX
            scaleVideoY = previewView.frame.size.height / videoSizeY
            scaleVideo = max(scaleVideoX, scaleVideoY)
            
            if scaleVideoX > scaleVideoY {
                transformedVideoRect.origin.y += (scaleVideo * videoSizeY - previewView.frame.size.height) / 2
            } else {
                transformedVideoRect.origin.x += (scaleVideo * videoSizeX - previewView.frame.size.width) / 2
            }
        } else {
            scaleVideoX = previewView.frame.size.width / videoSizeY
            scaleVideoY = previewView.frame.size.height / videoSizeX
            scaleVideo = max(scaleVideoX, scaleVideoY)
            
            if scaleVideoX > scaleVideoY {
                transformedVideoRect.origin.y += (scaleVideo * videoSizeX - previewView.frame.size.height) / 2
            } else {
                transformedVideoRect.origin.x += (scaleVideo * videoSizeY - previewView.frame.size.width) / 2
            }
        }
        
        let captureSizeTransform = CGAffineTransform(scaleX: 1/scaleVideo, y: 1/scaleVideo);
        scanner.capture.scanRect = transformedVideoRect.applying(captureSizeTransform);
    }
    
    fileprivate func updateStatusView(byResult result: CarInspectionCertificateQRCodeValidatationResult) {
        switch result {
        case let .success(_, progress):
            statusView.dismiss(completion: {
                self.statusView.status = .success(message: "✔ 続けて次のQRコードを読み込んで下さい")
                self.statusView.show(animationOption: .fade(duration: 0.1, delay: 0))
            })
            progressView.setProgress(progress, animated: true)
        case .failure(let reason):
            statusView.dismiss(completion: {
                self.statusView.status = .failure(message: reason.description)
                self.statusView.show(animationOption: .fade(duration: 0.1, delay: 0))
            })
        }
    }
    
    fileprivate func showCheckmarkIfSuccess(result: CarInspectionCertificateQRCodeValidatationResult) {
        if case .success = result {
            checkmark.show(autoDismiss: true, dismissOption: .fade(duration: 0.3, delay: 0.2))
        }
    }
}

// MARK: - CarInspectionCertificateQRCodeValidatorDelegate

extension CarQRCodeScannerViewController: CarInspectionCertificateQRCodeScannerDelegate {
    
    func scanner(_ scanner: CarInspectionCertificateQRCodeScanner, didValidate result: CarInspectionCertificateQRCodeValidatationResult) {
        showCheckmarkIfSuccess(result: result)
        updateStatusView(byResult: result)
    }
    
    func scanner(_ scanner: CarInspectionCertificateQRCodeScanner, didComplete certificate: CarInspectionCertificate) {
        successfulView.isHidden = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.stop()
            self.dismiss(animated: true, completion: {
                self.delegate?.qrScannerController(self.scannerController, didFinishScanning: certificate)
            })
        }
    }
    
}
