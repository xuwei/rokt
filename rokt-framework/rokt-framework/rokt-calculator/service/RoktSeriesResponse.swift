//
//  File.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 4/12/21.
//

import Foundation

public struct RoktSeriesRespones {
    let series: [Double]
    private(set) var sum: Double
    private(set) var average: Double
    
    public init(series: [Double]) {
        self.series = series
        self.sum = self.series.count > 0 ? self.series.reduce(0.0, +) : 0.0
        self.average = self.series.count > 0 ? self.sum / Double(self.series.count) : 0.0
    }
}
