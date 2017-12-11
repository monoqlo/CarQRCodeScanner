//
//  MainViewController.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/15.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit
import CarQRCodeScanner

class MainViewController: UIViewController {
    
    fileprivate var certificate: CarInspectionCertificate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func showCarInspectionCertificateDetailIfScanCompleted() {
        guard let _ = self.certificate else { return }
        self.performSegue(withIdentifier: "ToCarInspectionCertificateDetail", sender: nil)
    }
    
    @IBAction fileprivate func startScanButtonTouchedUpInside(_ sender: AnyObject) {
        let scanner = CarQRCodeScannerController()
        scanner.scannerDelegate = self
        self.present(scanner, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, let certificate = self.certificate, identifier == "ToCarInspectionCertificateDetail" else { return }
        
        let viewController = segue.destination as! CarInspectionCertificateTableViewController
        
        switch certificate {
        case .Standard(let standardCertificate):
            viewController.certificate = standardCertificate
        case .Light(let lightCertificate):
            viewController.certificate = lightCertificate
        }
    }

}

extension MainViewController: CarQRCodeScannerControllerDelegate {
    
    func qrScannerControllerDidCancel(_ scanner: CarQRCodeScannerController) {
        print("canceld!")
    }
    
    func qrScannerController(_ scanner: CarQRCodeScannerController, didFinishScanning certificate: CarInspectionCertificate) {
        print(certificate.standard as Any)
        
        self.certificate = certificate
        self.showCarInspectionCertificateDetailIfScanCompleted()
    }
    
}
