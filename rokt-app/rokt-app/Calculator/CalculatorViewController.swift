//
//  ViewController.swift
//  rokt-app
//
//  Created by Xuwei Liang on 1/12/21.
//

import UIKit

class CalculatorViewController: UIViewController, CalculatorViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    let presenter: CalculatorViewPresenterProtocol = CalculatorViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.bind(self)
        presenter.viewDidAppear()
    }
    
    // MARK: - CalculatorViewProtocol
    func render() {
        // refresh data
    }
    
    // MARK: - Private
    func setupUI() {
        title = "Calculator"
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
}

