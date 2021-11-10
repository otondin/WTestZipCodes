//
//  ViewController.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import UIKit

class ZipCodeListViewController: UITableViewController {
    
    private let viewModel: ZipCodeListViewModelDelegate
    private let cellIdentifier = "zipCodeCell"
    private var zipCodes = [ZipCodeModel]()
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
    private lazy var refreshButton: UIBarButtonItem  = {
        UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchZipCodes))
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
        fetchZipCodes()
    }
}

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
    }
    
    @objc func fetchZipCodes() {
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.fetchAllZipCodes() { result in
                guard let result = result else {
                    self?.activityIndicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                    self?.activityIndicator.removeFromSuperview()
                    self?.navigationItem.rightBarButtonItem = self?.refreshButton
                    return
                    
                }
                self?.zipCodes.append(contentsOf: result)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                    self?.activityIndicator.removeFromSuperview()
                    self?.navigationItem.rightBarButtonItem = self?.refreshButton
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredZipCodes = zipCodes.filter { $0.getCodPostal().contains(searchText) || $0.desigPostal.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

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

extension ZipCodeListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let text = searchBar.text {
            filterContentForSearchText(text)
        }
    }
}

