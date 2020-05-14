//
//  PopUp.swift
//  CarInspectionCertificateQRCodeReader
//
//  Created by monoqlo on 2016/08/18.
//  Copyright © 2016年 米山 隆貴. All rights reserved.
//

import UIKit

enum PopUpAnimationOptions {
    case none
    case fade(duration: TimeInterval, delay: TimeInterval)
    
    static func defaultFadeOut() -> PopUpAnimationOptions {
        return .fade(duration: 0.2, delay: 0.1)
    }
    
    static func defaultFadeIn() -> PopUpAnimationOptions {
        return .fade(duration: 0.3, delay: 0)
    }
}

protocol PopUp {
    func show(animationOption option: PopUpAnimationOptions, autoDismiss: Bool, dismissOption: PopUpAnimationOptions?, completion: (() -> Void)?)
    func dismiss(option: PopUpAnimationOptions, completion: (() -> Void)?)
}

extension PopUp where Self: UIView {

    func show(animationOption option: PopUpAnimationOptions = PopUpAnimationOptions.defaultFadeIn(), autoDismiss: Bool = false, dismissOption: PopUpAnimationOptions? = nil, completion: (() -> Void)? = nil) {
        isHidden = false
        
        let dismiss = {
            if autoDismiss == true {
                self.dismiss(option: dismissOption ?? PopUpAnimationOptions.defaultFadeOut(), completion: completion)
            } else {
                completion?()
            }
        }
        
        switch option {
        case .none:
            alpha = 1
            dismiss()
        case .fade:
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.alpha = 1
                }, completion: { (finished) in
                    dismiss()
            })
        }
    }
    
    func dismiss(option: PopUpAnimationOptions = PopUpAnimationOptions.defaultFadeOut(), completion: (() -> Void)? = nil) {
        switch option {
        case .none:
            alpha = 0
            isHidden = true
            completion?()
        case let .fade(duration, delay):
            UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions(), animations: {
                self.alpha = 0
                }, completion: { (finished) in
                    self.isHidden = true
                    completion?()
            })
        }
    }
    
}
