//
//  CalculatorFormValidator.swift
//  rokt-app
//
//  Created by Xuwei Liang on 5/12/21.
//

import Foundation

final class CalculatorFormValidator: Validator {
    func isValidInput(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return "Please enter a value"
        }
        
        guard text.count <= 10 else {
            return "Please limit to 10 or less characters"
        }
        
        guard let _ = Double(text) else {
            return "Please enter a numeric value"
        }
        return nil
    }
}
