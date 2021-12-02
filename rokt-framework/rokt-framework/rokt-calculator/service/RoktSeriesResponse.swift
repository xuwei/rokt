//
//  File.swift
//  rokt-framework
//
//  Created by Xuwei Liang on 4/12/21.
//

import Foundation

public struct RoktSeriesRespones {
    let series: [Double]
    private(set) var average: Double
    
    public init(series: [Double]) {
        self.series = series
        self.average = self.series.reduce(0.0, +) / Double(self.series.count)
    }
}
