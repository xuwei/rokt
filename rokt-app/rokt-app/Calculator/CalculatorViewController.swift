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
    let formStoryboardId = "CalculatorFormViewController"
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
            self.loadingIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func renderLoading() {
        tableView.isHidden = true
        loadingIndicator.startAnimating()
    }
    
    func showForm(context: CalculatorFormContext, delegate: CalculatorFormViewControllerDelegate?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: formStoryboardId) as? CalculatorFormViewController else { return }
        viewController.delegate = delegate
        viewController.presenter = CalculatorFormViewPresenter(with: context)
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated: true)
    }
    
    func dismiss() {
        self.dismiss(animated: true)
    }
    
    func showDialog(title: String, message: String) {
        // show alert text by message here
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Private
    func setupUI() {
        title = "Avg:--"
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapDelete))
    }
    
    @objc private func didTapAdd() {
        presenter.didTapAdd()
    }
    
    @objc private func didTapDelete() {
        presenter.didTapDelete()
    }
}

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let series = viewModel?.series else { return UITableViewCell() }
        let cellViewModel: RoktTableViewModelProtocol = series[indexPath.row]
        let cell: SeriesItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                                          for: indexPath) as! SeriesItemTableViewCell
        
        cell.configure(cellViewModel)
        return cell
    }
}

extension CalculatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.series.count ?? 0
    }
}
