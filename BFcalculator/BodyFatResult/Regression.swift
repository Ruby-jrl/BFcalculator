//
//  Navy.swift
//  BFcalculator
//
//  Created by Ruby Liu on 04/01/2025.
//

import SwiftUI

func RegressionCalculator(sex: String, waist: String, height: String, weight: String) -> Double? {
    
    if let waistNum = Double(waist),
       let weightNum = Double(weight),
       let heightNum = Double(height) {
        
        // regression models fat mass
        // ['E_Sex', 'E_Height', 'E_Weight', 'BMI', 'E_Waist1']
        let co = [8692.11044664, 61.50068029, 193.00768267, 898.59891144, 198.23709627] // coefficient
        let intercept = -45781.25657332
        
        let sexNum: Double = (sex == "Male") ? 0 : 1
        let BMI: Double = weightNum / ((heightNum / 100) * (heightNum / 100))
        let input = [sexNum, heightNum, weightNum, BMI, waistNum]
        
        let fat_mass_prediction = zip(co, input).map(*).reduce(0, +) + intercept
        let result = fat_mass_prediction * 0.001 / weightNum * 100
        print(result)
        print("Predicted Body Fat %: \(result)")
        return result
        
    }
        
    return nil
}
