//
//  Navy.swift
//  BFcalculator
//
//  Created by Ruby Liu on 04/01/2025.
//

import SwiftUI

func NavyMethodCalculator(sex: String, waist: String, neck: String, height: String, hip: String) -> Double? {
    
    if let waistNum = Double(waist),
       let neckNum = Double(neck),
       let heightNum = Double(height) {
        
        if sex == "Male" {
            // Formula for men
            // 1.0324-0.19077\log\left(80-40\right)+0.15456\log\left(170\right)
            // 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450
            let logWaistNeck = log10(waistNum - neckNum)
            let logHeight = log10(heightNum)
            let factor = 1.0324 - 0.19077 * logWaistNeck + 0.15456 * logHeight
            return 495 / factor - 450
        } else if let hipNum = Double(hip) {
            // Formula for women
            // 1.29579-0.35004\log\left(80+90-40\right)+0.22100\log\left(170\right)
            // 495 / (1.29579 - 0.35004 * log10(waist + hip - neck) + 0.22100 * log10(height)) - 450
            let logWaistHipNeck = log10(waistNum + hipNum - neckNum)
            let logHeight = log10(heightNum)
            let factor = 1.29579 - 0.35004 * logWaistHipNeck + 0.22100 * logHeight
            return 495 / factor - 450
        } else {
            return nil
        }
    }

    return nil
}
