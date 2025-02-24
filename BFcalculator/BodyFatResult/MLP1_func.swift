//
//  MLP1.swift
//  BFcalculator
//
//  Created by Ruby Liu on 12/02/2025.
//

import CoreML
import Foundation

func MLP1Calculator(sex: String, height: String, weight: String, waist: String) -> Double? {
    
    let feature_means = [0.53887671, 170.24127172, 77.88071344, 26.79599279, 90.69673495]
    let feature_stds = [0.49848631, 9.38225081, 15.73476582, 4.65251628, 13.16175787]
    
    if let waistNum = Double(waist),
       let weightNum = Double(weight),
       let heightNum = Double(height) {
        
        let BMI = weightNum / ((heightNum / 100) * (heightNum / 100))
        
        // load the CoreML model
        guard let model = try? MLP1() else {
            fatalError("Failed to load CoreML model")
        }

        // example input values: (Sex, Height, Weight, BMI, Waist)
        // let inputArray: [Double] = [1, 165, 50, 18.4, 64]
        let inputArray: [Double] = [(sex == "Male") ? 0 : 1 , heightNum, weightNum, BMI, waistNum]
        
        // standardize the input: (X - mean) / std
        var standardizedInput: [Double] = []
        for i in 0..<inputArray.count {
            let scaledValue = (inputArray[i] - feature_means[i]) / feature_stds[i]
            standardizedInput.append(scaledValue)
        }

        print("Standardized Input:", standardizedInput)  // Debugging
        
        
        // create MLMultiArray with shape (1, N)
        guard let mlMultiArray = try? MLMultiArray(shape: [1, NSNumber(value: standardizedInput.count)], dataType: .double) else {
            fatalError("Failed to create MLMultiArray")
        }

        // populate values
        for (i, value) in standardizedInput.enumerated() {
            mlMultiArray[i] = NSNumber(value: value)
        }

        // wrap in CoreML input class
        let modelInput = MLP1Input(x: mlMultiArray)  // Ensure correct wrapping

        // run prediction
        do {
            print(modelInput.x)
            let prediction = try model.prediction(input: modelInput)
            let result = (Double(truncating: prediction.var_27[0]) * 0.001) / inputArray[2] * 100
            print(prediction.var_27[0])
            print("Predicted Body Fat %: \(result)")
            return result
            
        } catch {
            print("Prediction failed: \(error)")
        }
        
        return nil
    }
        
    return nil
}
