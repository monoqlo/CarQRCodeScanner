//
//  CountingLabel.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/25.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit
import QuartzCore

typealias CountingLabelFormatter = (Double) -> String
typealias CountingLabelAttributedFormatter = (Double) -> NSAttributedString

class CountingLabel: UILabel {
    
    var animationOption: AnimationOption = .easeInOut
    var animationDuration: TimeInterval = 2.0
    
    /// this is executed when the counting animation finishes.
    var completionAction: (() -> Void)?
    
    var formatter: Formatter = Formatter.simple("%f") {
        didSet {
            setTextValue(currentValue, withFormatter: formatter)
        }
    }
    
    var currentValue: Double {
        if progress >= totalTime {
            return destinationValue
        }
        
        let progressRatio = progress / totalTime
        let updateValue = animationOption.adjust(progressRatio)
        return startingValue + (updateValue * (destinationValue - startingValue))
    }
    
    fileprivate var startingValue: Double = 0
    fileprivate var destinationValue: Double = 0
    fileprivate var progress: TimeInterval = 0
    fileprivate var lastUpdate: TimeInterval = 0
    fileprivate var totalTime: TimeInterval = 0
    fileprivate var easingRate: Double = 0
    
    fileprivate var displayLink: CADisplayLink?
    
    
    func count(from startValue: Double, to endValue: Double) {
        if animationDuration == 0.0 {
            animationDuration = 2.0
        }
        
        count(from: startValue, to: endValue, withDuration: animationDuration)
    }
    
    func count(from startValue: Double, to endValue: Double, withDuration duration: TimeInterval) {
        startingValue = startValue
        destinationValue = endValue
        
        self.displayLink?.invalidate()
        self.displayLink = nil
        
        if duration == 0.0 {
            // No animation
            setTextValue(endValue, withFormatter: formatter)
            completionAction?()
            return
        }
        
        easingRate = 3.0
        progress = 0
        totalTime = duration
        lastUpdate = Date().timeIntervalSinceReferenceDate
        
        let displayLink = CADisplayLink(target: self, selector: #selector(CountingLabel.updateValue(withDisplayLink:)))
        displayLink.preferredFramesPerSecond = 2
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.tracking)
        self.displayLink = displayLink
    }
    
    func countFromCurrentValue(to endValue: Double) {
        count(from: currentValue, to: endValue)
    }
    
    func countFromCurrentValue(to endValue: Double, withDuration duration: TimeInterval) {
        count(from: currentValue, to: endValue, withDuration: duration)
    }
    
    func countFromZero(to endValue: Double) {
        count(from: 0, to: endValue)
    }
    
    func countFromZero(to endValue: Double, withDuration duration: TimeInterval) {
        count(from: 0, to: endValue, withDuration: duration)
    }
    
    @objc fileprivate func updateValue(withDisplayLink displayLink: CADisplayLink) {
        let now = Date().timeIntervalSinceReferenceDate
        progress += now - lastUpdate
        lastUpdate = now
        
        if progress >= totalTime {
            self.displayLink?.invalidate()
            self.displayLink = nil
            progress = totalTime
        }
        
        setTextValue(currentValue, withFormatter: formatter)
        
        if progress == totalTime {
            completionAction?()
        }
    }
    
    fileprivate func setTextValue(_ value: Double, withFormatter formatter: Formatter) {
        switch formatter {
        case .simple(let format):
            if let _ = format.range(of: "%(.*)(d|i)", options: .regularExpression) {
                text = String(format:format, Int(value))
            } else {
                text = String(format:format, value)
            }
        case .decorate(let decorate):
            text = decorate(value)
        case .attributedDecorate(let decorate):
            attributedText = decorate(value)
        }
    }
}

extension CountingLabel {
    
    enum AnimationOption {
        case easeInOut
        case easeIn
        case easeOut
        case linear
        
        var counterRate: Double {
            return 3.0
        }
        
        func adjust(_ ratio: Double) -> Double {
            switch self {
            case .easeInOut:
                var sin: Double = 1.0
                let r = Int(counterRate)
                
                if r % 2 == 0 {
                    sin = -1.0
                }
                
                let doubledRatio = ratio * 2
                if doubledRatio < 1 {
                    return 0.5 * pow(doubledRatio, counterRate)
                } else {
                    return sin * 0.5 * (pow(doubledRatio-2, counterRate) + sin * 2)
                }
                
            case .easeIn:
                return pow(ratio, counterRate)
            case .easeOut:
                return 1.0-pow((1.0-ratio), counterRate)
            case .linear: 
                return ratio
            }
        }
    }
    
    enum Formatter {
        case simple(String)
        case decorate((Double) -> String)
        case attributedDecorate((Double) -> NSAttributedString)
    }
    
}
