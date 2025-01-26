//
//  BFcalculatorTests.swift
//  BFcalculatorTests
//
//  Created by Ruby Liu on 12/10/2024.
//

import Testing
import Foundation
@testable import BFcalculator

struct BFcalculatorTests {

    @Test("display name (traits) of the test")
    func example() async throws {
        try #require(1 == 1)
        #expect(2 == 2)
    }
    
    // Parameterized test for Navy method
    @Test("Test Navy method", arguments: [
        ["170.0", "80.0", "Female", "40.0", "90.0", "22.0"], // height, waist, sex, neck, hip, expected
        ["180.0", "85.0", "Male", "42.0", "", "12.9"],
        ["160.0", "70.0", "Female", "38.0", "85.0", "17.4"],
        ["", "", "Male", "", "", ""]
    ])
    func navy(arguments: [String]) async throws {
        // Extract the parameters from the arguments array
        let height = arguments[0]
        let waist = arguments[1]
        let sex = arguments[2]
        let neck = arguments[3]
        let hip = arguments[4]
        let expected = Double(arguments[5]) // returns nil if ""

        let result: Double? = BFcalculator.NavyMethodCalculator(selectedGender: sex, waist: waist, neck: neck, height: height, hip: hip)
        let roundedResult: Double? = result.map { ($0 * 10).rounded() / 10 }

        #expect(roundedResult == expected)
    }

    // Parameterized test for Neural Network method
    @Test("Test Neural Network method",
          .enabled(if: isServerUp()), // only runs if the server is up
          arguments: [
            ["170.0", "60.0", "Female", "70.0", "29.1"], // height, weight, sex, waist, expected
            ["180.0", "85.0", "Male", "82.0", "22.1"],
            ["160.0", "70.0", "Female", "85.0", "39.8"],
            ["", "", "Male", "", ""]
    ])
    func neuralNetwork(arguments: [String]) async throws {
        let height = arguments[0]
        let weight = arguments[1]
        let sex = arguments[2]
        let waist = arguments[3]
        let expected = Double(arguments[4]) // returns nil if ""
        
        let result = await asyncNNCalculatorWrapper(sex: sex, height: height, weight: weight, waist: waist)

        // Round the result for comparison
        let roundedResult: Double? = result.map { ($0 * 10).rounded() / 10 }

        // Assert: Check the result matches the expected value
        #expect(roundedResult == expected, "Expected \(expected ?? -1), but got \(roundedResult ?? -1)")
    }

    // Helper function to check if the server is up
    static func isServerUp() -> Bool {
        let urlString = "http://127.0.0.1:5000/predict"
        guard let url = URL(string: urlString) else {
            return false // Invalid URL
        }
        
        var serverIsUp = false
        let semaphore = DispatchSemaphore(value: 0) // To wait for the request to complete
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 400 {
                serverIsUp = true
            } else {
                serverIsUp = false
            }
            semaphore.signal() // Signal that the task is complete
        }

        task.resume()
        semaphore.wait() // Wait for the task to complete
        
        return serverIsUp
    }
    
    
    // test for history tracking
    
    // test for nearest neighbor

}
