//
//  CalculatorFormViewPresenter.swift
//  rokt-app
//
//  Created by Xuwei Liang on 5/12/21.
//

import Foundation

protocol CalculatorFormViewProtocol: AnyObject {
    func render(with viewModel: CalculatorFormViewModel)
    func submit(with context: CalculatorFormContext)
    func dismiss()
}

protocol CalculatorFormViewPresenterDelegate {
    func bind(_ view: CalculatorFormViewProtocol)
    func didEnteredText(_ text: String)
    func didTapSubmit()
    func didTapCancel()
}

struct CalculatorFormViewModel {
    let title: String
    let placeHolderText: String
    let captionText: String
    let submitEnabled: Bool
}

final class CalculatorFormViewPresenter: CalculatorFormViewPresenterDelegate {
    let context: CalculatorFormContext
    weak var view: CalculatorFormViewProtocol?
    var textEntry: String?
    var validationMessage: String?
    
    init(with context: CalculatorFormContext) {
        self.context = context
    }
    
    // MARK: - CalculatorFormViewPresenterDelegate
    func bind(_ view: CalculatorFormViewProtocol) {
        self.view = view
        render()
    }
    
    func didEnteredText(_ text: String) {
        self.textEntry = text
        validationMessage = isValidInput(text)
        render()
    }
    
    func didTapSubmit() {
        view?.submit(with: context)
    }
    
    func didTapCancel() {
        view?.dismiss()
    }
    
    // MARK: - Private
    private func render() {
        let title = context == .add ? "Add" : "Delete"
        let placeHolder = context == .add ? "New value to the series..." : "Enter value from the series..."
        let submitEnabled = validationMessage == nil ? true : false
        let viewModel = CalculatorFormViewModel(title: title,
                                                placeHolderText: placeHolder,
                                                captionText: validationMessage ?? "",
                                                submitEnabled: submitEnabled)
        view?.render(with: viewModel)
    }
    
    private func isValidInput(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return "Please enter a value"
        }
        guard let _ = Double(text) else {
            return "Please enter a numeric value"
        }
        return nil
    }
}
