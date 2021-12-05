//
//  Validator.swift
//  rokt-app
//
//  Created by Xuwei Liang on 5/12/21.
//

import Foundation

protocol Validator {
    func isValidInput(_ text: String?) -> String?
}
