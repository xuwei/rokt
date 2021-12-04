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
    let cellIdentifier = "SeriesItemTableViewCell"
    
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let rightButton = UIBarButtonItem(title: self.presenter.viewModel?.editToggleTitle,
                                              style: .plain,
                                              target: self,
                                              action: #selector(self.toggleEdit))
            self.navigationItem.setRightBarButton(rightButton, animated: true)
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
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(toggleEdit))
    }
    
    @objc private func toggleEdit() {
        presenter.didToggleEdit()
    }
}

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let series = presenter.viewModel?.series else { return UITableViewCell() }
        let cellViewModel: RoktTableViewModelProtocol = series[indexPath.row]
        let cell: SeriesItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                                          for: indexPath) as! SeriesItemTableViewCell
        
        cell.configure(cellViewModel, delegate: self)
        return cell
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModel?.series.count ?? 0
    }
}

extension CalculatorViewController: SeriesItemTableViewCellDelgate {
    func deleteItemFromSeries(_ cell: SeriesItemTableViewCell) {
        presenter.didTapDeleteItem()
    }
}
