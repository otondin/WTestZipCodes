//
//  ViewController.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import UIKit

class ZipCodeListViewController: UITableViewController {
    
    // MARK:- Private properties
    
    private var viewModel: ZipCodeListViewModel
    private var zipCodes = [ZipCodeModel]() {
        didSet {
            updateUI()
        }
    }
    private var filteredZipCodes = [ZipCodeModel]()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pesquisar..."
        return searchController
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        return view
    }()
    private lazy var activityButton: UIBarButtonItem = {
        let view = UIBarButtonItem(customView: activityIndicator)
        return view
    }()
    private lazy var refreshButton: UIBarButtonItem  = {
        UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
    }()
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    private var isLoading: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    private let cellIdentifier = "zipCodeCell"
    
    // MARK:- Lyfecicle methods

    override init(style: UITableView.Style) {
        self.viewModel = ZipCodeListViewModel()
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configure()
        fetchData()
    }
}

// MARK:- Private extension
private extension ZipCodeListViewController {
    func setupViews() {
        view.addSubview(activityIndicator)
    }
    
    func configure() {
        title = "Códigos Postais"
        tableView.register(ZipCodeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationItem.rightBarButtonItem = refreshButton
        navigationItem.searchController = searchController
        definesPresentationContext = true
        viewModel.delegate = self
    }
    
    @objc func fetchData() {
        updateUI()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.fetchData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredZipCodes = zipCodes.filter { $0.getCodPostal().contains(searchText) || $0.desigPostal.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            if let activityIndicator = self?.activityIndicator {
                if activityIndicator.isAnimating {
                    self?.activityIndicator.stopAnimating()
                    self?.navigationItem.rightBarButtonItem = self?.refreshButton
                    self?.tableView.reloadData()
                } else {
                    self?.activityIndicator.startAnimating()
                    self?.navigationItem.rightBarButtonItem = self?.activityButton
                }
            }
        }
        
    }
}

// MARK:- UITableViewDataSource extension

extension ZipCodeListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredZipCodes.count
        } else {
            return zipCodes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ZipCodeTableViewCell
        let zipCode: ZipCodeModel
        if isFiltering {
            zipCode = filteredZipCodes[indexPath.row]
        } else {
            zipCode = zipCodes[indexPath.row]
        }
        cell.textLabel?.text = zipCode.getCodPostal()
        cell.detailTextLabel?.text = zipCode.desigPostal
        return cell
    }
}

// MARK:- UISearchResultsUpdating extension

extension ZipCodeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterContentForSearchText(text)
        }
    }
}

// MARK:- ZipCodeListViewModelOutput extension

extension ZipCodeListViewController: ZipCodeListViewModelOutput {
    func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.navigationItem.rightBarButtonItem = self?.refreshButton
            let alert = UIAlertController(title: "Ooops!", message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                self?.fetchData()
            }
            alert.addAction(defaultAction)
            alert.addAction(retryAction)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func pull(data: [ZipCodeModel]) {
        zipCodes = data
    }
}
