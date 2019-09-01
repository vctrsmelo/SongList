//
//  ShuffleListViewController.swift
//  Shuffle Songs
//
//  Created by Victor S Melo on 30/08/19.
//  Copyright © 2019 Victor S Melo. All rights reserved.
//

import UIKit

class ShuffleListViewController: UIViewController {

    // MARK: - Properties
    
    let viewModel: ShuffleListViewModel
    
    var rightBarButtonItem: UIBarButtonItem!
    
    private let cellID = "songCellID"
    let tableView = UITableView()
    
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    // MARK: - Init
    init(viewModel: ShuffleListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = DesignConfigurator.backgroundColor
        tableView.backgroundColor = DesignConfigurator.backgroundColor
        
        setupNavigationBar()
        setupTableView()
        setupActivityIndicator()
        
        self.updateView(viewModel.viewState)
    }
    
    private func setupNavigationBar() {
        title = "Shuffle Songs"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: DesignConfigurator.fontNavigationBarColor,
            .font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        ]
        
        navigationController?.navigationBar.barTintColor = DesignConfigurator.navigationBarColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black

        rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "shuffleButton"), style: .plain, target: self, action: #selector(didTapShuffleBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: cellID)
        
        self.tableView.separatorColor = UIColor(red: 55/255, green: 45/255, blue: 56/255, alpha: 1)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @objc
    func didTapShuffleBarButton(_ sender: UIBarButtonItem) {
        self.viewModel.didTapShuffleButton()
    }
    
    // MARK: - Others
    
    func updateView(_ state: ViewState) {
        switch state {
        case .error(let description):
            let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            break
        case .loading:
            tableView.isHidden = true
            activityIndicator.isHidden = false
            rightBarButtonItem.isEnabled = false
            activityIndicator.startAnimating()
            break
        case .showing:
            activityIndicator.stopAnimating()
            rightBarButtonItem.isEnabled = true
            tableView.isHidden = false
        default:
            break
        }
    }
}

extension ShuffleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemLength
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SongTableViewCell else {
            fatalError("could not get SongTableViewCell (this should never happens)")
        }
        
        let item = viewModel.getItem(at: indexPath.row)
        cell.configure(title: item.title, subtitle: item.subtitle, image: item.image)
        
        return cell
    }
    
}

extension ShuffleListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ShuffleListViewController: ShuffleListViewModelDelegate {
    func updateView(_ state: ViewState, viewModel: ShuffleListViewModel) {
        updateView(state)
    }
    
    func didUpdateSongs(viewModel: ShuffleListViewModel) {
        self.tableView.reloadData()
    }
}
