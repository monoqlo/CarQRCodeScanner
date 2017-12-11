//
//  CarInspectionCertificateQRScannerController.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/15.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

open class CarQRCodeScannerController: UINavigationController {

    open weak var scannerDelegate: CarQRCodeScannerControllerDelegate? {
        get {
            return scanner?.delegate
        }
        
        set {
            scanner?.delegate = newValue
        }
    }
    
    fileprivate weak var scanner: CarQRCodeScannerViewController? {
        get {
            return viewControllers.first as? CarQRCodeScannerViewController
        }
    }
    
    // MARK: - Initializer
    
    override fileprivate init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init() {
        self.init(rootViewController: CarQRCodeScannerViewController.instantiateFromStoryboard())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // MARK: -
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
