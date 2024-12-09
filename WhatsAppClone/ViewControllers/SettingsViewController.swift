//
//  SettingsViewController.swift
//  WhatsAppClone
//
//  Created by Admin on 06/02/24.
//

import UIKit

class SettingsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    var data: [String] = [] // Your data array
    
    var filteredData: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the search bar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        // Set up the table view
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Initialize your data array
        // data = [...]

        // Initially, display all data
        filteredData = data
    }
    
    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter the data based on the search text
        filteredData = data.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
}
