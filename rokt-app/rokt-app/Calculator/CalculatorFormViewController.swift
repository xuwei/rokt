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

class CalculatorFormViewController: UIViewController {
    @IBOutlet private weak var inputField: UITextField!
    var context: CalculatorFormContext
    weak var delegate: CalculatorFormViewControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        self.context = .add
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private
    private func setupUI() {
        self.title = context == .add ? "Add" : "Remove"
        self.inputField.placeholder = "Please enter numeric value..."
        self.inputField.keyboardType = .numbersAndPunctuation
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSubmit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapCancel))
    }
    
    // MARK: - Private
    @objc private func didTapCancel() {
        delegate?.cancel()
    }
    
    @objc private func didTapSubmit() {
        guard let inputFieldText = inputField?.text else { return }
        delegate?.textEntered(inputFieldText, context: context)
    }
}

extension CalculatorFormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        guard let _ = Double(text) else { return false }
        textField.resignFirstResponder()
        return true
    }
}
