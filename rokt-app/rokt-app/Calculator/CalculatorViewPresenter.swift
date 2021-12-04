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
    func render(with viewState: CalculatorViewState)
    func showDialog(title: String, message: String)
    func showForm(context: CalculatorFormContext,delegate: CalculatorFormViewControllerDelegate?)
    func dismiss()
}

// MARK: - CalculatorViewPresenterProtocol
protocol CalculatorViewPresenterProtocol {
    func bind(_ view: CalculatorViewProtocol)
    func viewDidAppear()
    func didTapAdd()
    func didTapDelete()
}

// MARK: - CalculatorViewModel
struct CalculatorViewModel {
    let series: [SeriesItemTableViewCellViewModel]
    let average: String
}

enum CalculatorViewState {
    case loaded(viewModel: CalculatorViewModel)
    case loading
}

// MARK: - CalculatorViewPresenter
final class CalculatorViewPresenter: CalculatorViewPresenterProtocol {
    private let service: RoktCalculatorService
    private var viewModel: CalculatorViewModel?
    private var view: CalculatorViewProtocol?
    
    init(configuration: CalculatorConfiguration = CalculatorConfiguration()) {
        self.service = RoktCalculatorService(baseURLString: configuration.baseURLString)
    }
    
    // MARK: - CalculatorViewPresenterProtocol
    func bind(_ view: CalculatorViewProtocol) {
        self.view = view
    }
    
    func viewDidAppear() {
        fetchData()
    }
    
    
    // MARK: - CalculatorViewPresenterProtocol
    func didTapAdd() {
        view?.showForm(context: .add, delegate: self)
    }
    
    func didTapDelete() {
        view?.showForm(context: .delete, delegate: self)
    }
    
    // MARK: - CalculatorViewProtocol
    func render() {
        guard let viewModel = viewModel else { return }
        view?.render(with: .loaded(viewModel: viewModel))
    }
    
    func loading() {
        view?.render(with: .loading)
    }
    
    // MARK: - Private
    private func fetchData() {
        let factory = RoktCalculatorCommandFactory(for: service)
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .neverExpires) else { return }
        loading()
        service.fetchSeries(with: command) { [weak self] (result: Result<RoktSeriesResponse, RoktNetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let seriesResponse):
                let seriesItems: [SeriesItemTableViewCellViewModel] = seriesResponse.series.map {
                    SeriesItemTableViewCellViewModel(value: String(format: "%.5f", $0),
                                                     textColor: $0 >= 0.0 ? .green : .red)
                }
                
                self.viewModel = CalculatorViewModel(series: seriesItems,
                                                     average: String(format: "%.5f", seriesResponse.average))
                self.render()
            case .failure(let err):
                self.viewModel = CalculatorViewModel(series: [], average: "--")
                self.render()
                self.view?.showDialog(title: "Error", message: err.localizedDescription)
            }
        }
    }
    
    private func addToSeries(_ value: Double) {
        let factory = RoktCalculatorCommandFactory(for: service)
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .neverExpires) else { return }
        if service.addToSeries(value, for: command) {
            fetchData()
        } else {
            self.view?.showDialog(title: "Unable to add \(value)", message: "Already existed in series")
        }
    }
    
    private func removeNumberFromSeries(_ value: Double) {
        let factory = RoktCalculatorCommandFactory(for: service)
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .neverExpires) else { return }
        if service.removeNumberFromSeries(value, for: command) {
            fetchData()
        } else {
            self.view?.showDialog(title: "Unable to delete \(value)", message: "Missing in the series")
        }
    }
}

extension CalculatorViewPresenter: CalculatorFormViewControllerDelegate {
    func textEntered(_ text: String, context: CalculatorFormContext) {
        view?.dismiss()
        if let numericValue = Double(text) {
            switch context {
            case .add:
                addToSeries(numericValue)
            case .delete:
                removeNumberFromSeries(numericValue)
            }
        }
    }
    
    func cancel() {
        view?.dismiss()
    }
}
