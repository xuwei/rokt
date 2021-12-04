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
    func didTapAddItem()
    func didTapDeleteItem()
    func didToggleEdit()
    var viewModel: CalculatorViewModel? { get }
}

// MARK: - CalculatorViewContext
enum CalculatorViewContext: String {
    case edit = "Edit"
    case view = "View"
}

// MARK: - CalculatorViewModel
struct CalculatorViewModel {
    let series: [SeriesItemTableViewCellViewModel]
    let average: String
    let context: CalculatorViewContext
    var editToggleTitle: String { context == .edit ? "View" : "Edit" }
    var showDeleteButton: Bool { context == .edit }
}

// MARK: - CalculatorViewPresenter
final class CalculatorViewPresenter: CalculatorViewPresenterProtocol {
    let service: RoktCalculatorService
    var viewModel: CalculatorViewModel?
    var view: CalculatorViewProtocol?
    var context: CalculatorViewContext = .view
    
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
    func didTapAddItem() {
        
    }
    
    func didTapDeleteItem() {
        
    }
    
    func didToggleEdit() {
        guard let viewModel = viewModel else { return }
        context = context == .edit ? .view : .edit
        let updatedSeries = viewModel.series.map {
            SeriesItemTableViewCellViewModel(value: $0.value,
                                             textColor: $0.textColor,
                                             showDeleteButton: context == .edit)
        }
        let updatedCalculatorViewModel = CalculatorViewModel(series: updatedSeries, average: viewModel.average, context: context)
        self.viewModel = updatedCalculatorViewModel
        render()
    }
    
    // MARK: - CalculatorViewProtocol
    func render() {
        view?.render()
    }
    
    // MARK: - Private
    private func fetchData() {
        let factory = RoktCalculatorCommandFactory(for: service)
        guard let command = factory.makeRoktCalculatorFetchSeriesCommand(with: .neverExpires) else { return }
        service.fetchSeries(with: command) { [weak self] (result: Result<RoktSeriesResponse, RoktNetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let seriesResponse):
                let seriesItems: [SeriesItemTableViewCellViewModel] = seriesResponse.series.map {
                    SeriesItemTableViewCellViewModel(value: String(format: "%.5f", $0),
                                                     textColor: $0 >= 0.0 ? .green : .red,
                                                     showDeleteButton: self.context == .edit)
                }
                
                self.viewModel = CalculatorViewModel(series: seriesItems,
                                                     average: String(format: "%.5f", seriesResponse.average),
                                                     context: self.context)
                self.render()
            case .failure(let err):
                self.view?.showDialog(message: err.localizedDescription)
            }
        }
    }
}
