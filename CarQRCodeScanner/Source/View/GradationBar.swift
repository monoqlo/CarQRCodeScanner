//
//  GradationBar.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/16.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

@IBDesignable class GradationBar: UIView {
    
    @IBInspectable var startColor : UIColor = #colorLiteral(red: 0.733, green: 0.835, blue: 0.718, alpha: 1)
    @IBInspectable var endColor : UIColor = #colorLiteral(red: 0.271, green: 0.729, blue: 0.694, alpha: 1)
    
    fileprivate var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = nil
        updateGradientLayer()
    }
    
    fileprivate func updateGradientLayer() {
        self.gradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
}
