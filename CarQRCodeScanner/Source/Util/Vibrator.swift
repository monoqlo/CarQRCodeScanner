//
//  Vibrator.swift
//  CarCompatibilityChecker
//
//  Created by monoqlo on 2016/04/26.
//  Copyright © 2016年 Nordic Semiconductor. All rights reserved.
//

import Foundation
import AudioToolbox

class Vibrator {
    class func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
