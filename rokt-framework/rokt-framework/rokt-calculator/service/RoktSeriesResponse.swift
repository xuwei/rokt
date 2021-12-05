//
//  File.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 4/12/21.
//

import Foundation

public struct RoktSeriesResponse {
    public let series: [Double]
    private(set) var _sum: Double
    private(set) var _average: Double
    public var sum: Double { _sum }
    public var average: Double { _average }
    
    public init(series: [Double]) {
        self.series = series
        self._sum = self.series.count > 0 ? self.series.reduce(0.0, +) : 0.0
        self._average = self.series.count > 0 ? self._sum / Double(self.series.count) : 0.0
    }
    
    
}
