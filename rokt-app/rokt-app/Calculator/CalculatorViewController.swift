//
//  ViewController.swift
//  rokt-app
//
//  Created by Xuwei Liang on 1/12/21.
//

import UIKit

class CalculatorViewController: UIViewController, CalculatorViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    let presenter: CalculatorViewPresenterProtocol = CalculatorViewPresenter()
    let cellIdentifier = "SeriesItemTableViewCell"
    private(set) var viewModel: CalculatorViewModel?
    
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
    func render(with viewState: CalculatorViewState) {
        switch viewState {
        case .loaded(let viewModel):
            renderLoaded(with: viewModel)
        case .loading:
            renderLoading()
        }
    }
    
    func renderLoaded(with viewModel: CalculatorViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewModel = viewModel
            self.title = String("Avg: \(viewModel.average)")
            let rightButton = UIBarButtonItem(title: viewModel.editToggleTitle,
                                              style: .plain,
                                              target: self,
                                              action: #selector(self.toggleEdit))
            self.navigationItem.setRightBarButton(rightButton, animated: true)
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func renderLoading() {
        tableView.isHidden = true
        loadingIndicator.startAnimating()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
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
        guard let series = viewModel?.series else { return UITableViewCell() }
        let cellViewModel: RoktTableViewModelProtocol = series[indexPath.row]
        let cell: SeriesItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                                          for: indexPath) as! SeriesItemTableViewCell
        
        cell.configure(cellViewModel, delegate: self)
        return cell
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.series.count ?? 0
    }
}

extension CalculatorViewController: SeriesItemTableViewCellDelgate {
    func deleteItemFromSeries(_ cell: SeriesItemTableViewCell) {
        presenter.didTapDeleteItem()
    }
}
