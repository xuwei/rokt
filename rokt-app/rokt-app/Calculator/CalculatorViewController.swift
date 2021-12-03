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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showDialog(message: String) {
        // show alert text by message here
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
        guard let series = presenter.viewModel?.series else { return UITableViewCell() }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
        cell.textLabel?.text = series[indexPath.row]
        return cell
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModel?.series.count ?? 0
    }
}

