//
//  CalculatorViewPresenter.swift
//  rokt-app
//
//  Created by Xuwei Liang on 1/12/21.
//

import Foundation
import rokt_framework

// MARK: - CalculatorViewProtocol
protocol CalculatorViewProtocol {
    func render()
}

// MARK: - CalculatorViewPresenterProtocol
protocol CalculatorViewPresenterProtocol {
    func bind(_ view: CalculatorViewProtocol)
    func viewDidAppear()
}

// MARK: - CalculatorViewPresenter
final class CalculatorViewPresenter: CalculatorViewPresenterProtocol {
    let service: RoktCalculatorService
    var view: CalculatorViewProtocol?
    
    init(configuration: CalculatorConfiguration = CalculatorConfiguration()) {
        self.service = RoktCalculatorService(baseURLString: configuration.baseURLString)
    }
    
    // MARK: - CalculatorViewPresenterProtocol
    func bind(_ view: CalculatorViewProtocol) {
        self.view = view
    }
    
    func viewDidAppear() {
        // fetch data
        guard let command = RoktCalculatorCommandFactory.makeRoktCalculatorFetchSeriesCommand(for: service) else { return }
        service.fetchSeries(with: command) { result in
            switch result {
            case .success(let series):
                print(series)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - CalculatorViewProtocol
    func render() {
        view?.render()
    }
}
