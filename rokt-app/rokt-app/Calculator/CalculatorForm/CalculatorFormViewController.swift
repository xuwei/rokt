//
//  CalculatorFormViewController.swift
//  rokt-app
//
//  Created by Xuwei Liang on 4/12/21.
//

import UIKit

enum CalculatorFormContext {
    case add
    case delete
}

protocol CalculatorFormViewControllerDelegate: AnyObject {
    func textEntered(_ text: String, context: CalculatorFormContext)
    func cancel()
}

class CalculatorFormViewController: UIViewController, CalculatorFormViewProtocol {
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    var presenter: CalculatorFormViewPresenterDelegate?
    weak var delegate: CalculatorFormViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
        presenter?.bind(self)
    }
    
    // MARK:- CalculatorFormViewProtocol
    func render(with viewModel: CalculatorFormViewModel) {
        self.title = viewModel.title
        self.captionLabel.text = viewModel.captionText
        self.inputField.placeholder = viewModel.placeHolderText
        navigationItem.rightBarButtonItem?.isEnabled = viewModel.submitEnabled
    }
    
    func submit(with context: CalculatorFormContext) {
        guard let text = inputField?.text else { return }
        delegate?.textEntered(text, context: context)
    }
    
    func dismiss() {
        delegate?.cancel()
    }

    // MARK: - Private
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSubmit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapCancel))
    }
    
    @objc private func didTapCancel() {
        presenter?.didTapCancel()
    }
    
    @objc private func didTapSubmit() {
        presenter?.didTapSubmit()
    }
}

extension CalculatorFormViewController {
    override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}

extension CalculatorFormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        presenter?.didEnteredText(textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
