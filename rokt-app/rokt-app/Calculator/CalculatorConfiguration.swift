//
//  CalculatorEnvironments.swift
//  rokt-app
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation

enum Environment {
    case dev
}

final class CalculatorConfiguration {
    let enviroment: Environment
    
    init(enviroment: Environment = .dev) {
        self.enviroment = enviroment
    }
    
    var baseURLString: String {
        switch enviroment {
        case .dev:
            return "https://roktcdn1.akamaized.net"
        }
    }
}


