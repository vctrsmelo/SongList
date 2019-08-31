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
    
    private let cellID = "songCellID"
    let tableView: UITableView
    
    // MARK: - Init
    init(viewModel: ShuffleListViewModel) {
        self.viewModel = viewModel
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        self.view.addSubview(tableView)
        
        self.tableView.register(SongTableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        tableView.dataSource = self
        
    }
    
    // MARK: - Actions
    
    // MARK: - Others
    
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
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
}

extension ShuffleListViewController: ShuffleListViewModelDelegate {
    func didUpdateSongs(viewModel: ShuffleListViewModel) {
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }
}
