//
//  Navy.swift
//  BFcalculator
//
//  Created by Ruby Liu on 04/01/2025.
//

import SwiftUI

func NavyMethodCalculator(selectedGender: String, waist: String, neck: String, height: String, hip: String) -> Double? {
    
    if let waistNum = Double(waist),
       let neckNum = Double(neck),
       let heightNum = Double(height) { // Convert heightString to Double
        
        if selectedGender == "Male" {
            // Formula for men
            // 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450
            let waistMinusNeck = waistNum - neckNum
            let logWaistNeck = log10(waistMinusNeck)
            let logHeight = log10(heightNum)
            let factor = 1.0324 - 0.19077 * logWaistNeck + 0.15456 * logHeight
            return 495 / factor - 450
        } else if let hipNum = Double(hip) {
            // Formula for women
            // 495 / (1.29579 - 0.35004 * log10(waist + hip - neck) + 0.22100 * log10(height)) - 450
            let waistPlusHipMinusNeck = waistNum + hipNum - neckNum
            let logWaistHipNeck = log10(waistPlusHipMinusNeck)
            let logHeight = log10(heightNum)
            let factor = 1.29579 - 0.35004 * logWaistHipNeck + 0.22100 * logHeight
            return 495 / factor - 450
        } else {
            return nil
        }
    }

    return nil
}
