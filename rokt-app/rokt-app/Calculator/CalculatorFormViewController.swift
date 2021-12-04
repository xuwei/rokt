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
    func textEntered(_ text: String)
    func cancel()
}

class CalculatorFormViewController: UIViewController, UITextFieldDelegate {
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
        self.view.backgroundColor = context == .add ? .green : .blue
    }
}
