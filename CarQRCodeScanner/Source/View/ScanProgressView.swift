//
//  ScanProgressView.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/17.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

class ScanProgressView: UIView {
    
    var progress: Double {
        get {
            return _progress
        }
        
        set {
            setProgress(newValue, animated: false)
        }
    }
    
    fileprivate var _progress: Double = 0
    
    fileprivate let progressBarHorizontalMarginMax: CGFloat = 11
    
    @IBOutlet fileprivate var contentView: UIView!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var progressBar: GradationBar!
    @IBOutlet fileprivate weak var progressLabel: CountingLabel!
    @IBOutlet fileprivate weak var progressBarTrailingConstraint: NSLayoutConstraint!
    
    
    fileprivate func commonInit() {
        Bundle(for: ScanProgressView.self).loadNibNamed("ScanProgressView", owner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        
        progressLabel.formatter = CountingLabel.Formatter.simple("%d%%")
        progressLabel.animationOption = CountingLabel.AnimationOption.easeIn
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setProgress(progress, animated: false)
    }
    
    func setProgress(_ progress: Double, animated: Bool) {
        let oldValue = _progress
        let newValue = filter(progress)
        _progress = newValue
        
        let newConstant = -bounds.width * CGFloat(1.0 - newValue) - progressBarHorizontalMarginMax
        progressBarTrailingConstraint.constant = newConstant
        
        if animated == true {
            let delta = TimeInterval(newValue - oldValue)
            setProgressText(newValue, duration: delta * 1.5)
            UIView.animate(withDuration: delta, delay: 0, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
                }, completion:nil)
        } else {
            layoutIfNeeded()
            setProgressText(newValue, duration: 0)
        }
    }
    
    fileprivate func filter(_ value: Double) -> Double {
        if value < 0 {
            return 0
        } else if value > 1 {
            return 1
        } else {
            return value
        }
    }
    
    fileprivate func setProgressText(_ progress: Double, duration: TimeInterval) {
        progressLabel.animationDuration = duration
        let intValue = Int(progress * 100)
        
        progressLabel.completionAction = { [weak self] () -> Void in
            let textColor: UIColor
            if intValue == 100 {
                textColor = UIColor.Scanner.progressBarCompletedText
                self?.runCompletedProgressAnimation()
            } else {
                textColor = UIColor.Scanner.progressBarNormalText
            }
            
            self?.progressLabel.textColor = textColor
        }
        
        progressLabel.countFromCurrentValue(to: Double(intValue))
    }
    
    fileprivate func runCompletedProgressAnimation() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.progressLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.progressLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.progressLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                        })
                })
        })
    }
    
}
