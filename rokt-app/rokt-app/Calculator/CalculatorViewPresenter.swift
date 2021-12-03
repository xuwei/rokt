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
    func showDialog(message: String)
}

// MARK: - CalculatorViewPresenterProtocol
protocol CalculatorViewPresenterProtocol {
    func bind(_ view: CalculatorViewProtocol)
    func viewDidAppear()
    var viewModel: CalculatorViewModel? { get }
}

// MARK: - CalculatorViewModel
struct CalculatorViewModel {
    let series: [String]
    let average: String
}

// MARK: - CalculatorViewPresenter
final class CalculatorViewPresenter: CalculatorViewPresenterProtocol {
    let service: RoktCalculatorService
    var viewModel: CalculatorViewModel?
    var view: CalculatorViewProtocol?
    
    init(configuration: CalculatorConfiguration = CalculatorConfiguration()) {
        self.service = RoktCalculatorService(baseURLString: configuration.baseURLString)
    }
    
    // MARK: - CalculatorViewPresenterProtocol
    func bind(_ view: CalculatorViewProtocol) {
        self.view = view
    }
    
    func viewDidAppear() {
        let factory = RoktCalculatorCommandFactory(for: service)
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .neverExpires) else { return }
        service.fetchSeries(with: command) { [weak self] (result: Result<RoktSeriesResponse, RoktNetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let seriesResponse):
                let seriesStringify: [String] = seriesResponse.series.map { return String(format: "%.5f", $0) }
                self.viewModel = CalculatorViewModel(series: seriesStringify,
                                                    average: String(format: "%.5f", seriesResponse.average))
                self.render()
            case .failure(let err):
                self.view?.showDialog(message: err.localizedDescription)
            }
        }
    }
    
    // MARK: - CalculatorViewProtocol
    func render() {
        view?.render()
    }
}
