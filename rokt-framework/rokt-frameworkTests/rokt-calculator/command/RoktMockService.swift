//
//  RoktMockService.swift
//  rokt-frameworkTests
//
//  Created by Xuwei Liang on 4/12/21.
//

import Foundation
import rokt_framework

final class RoktMockService: RoktService {
    var baseURLString: String
    
    init(with baseUrlString: String) {
        baseURLString = baseUrlString
    }
}
