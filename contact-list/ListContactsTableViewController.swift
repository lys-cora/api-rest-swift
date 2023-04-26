//
//  ListContactsTableViewController.swift
//  contact-list
//
//  Created by Amaryllis Rosemaria Baldrez Calefi on 25/04/23.
//
import UIKit

class ListContactsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people: [Person]
    let cellReuseIdentifier = "MyTableViewCell"
    var tableView: UITableView!
    var data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    init(people: [Person]) {
        self.people = people
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create table view
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyTableViewCell
        cell.titleLabel.text = people[indexPath.row].name
        cell.subtitleLabel.text = people[indexPath.row].phone
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(people[indexPath.row].name)
        let controller = AlertContactViewController()
        present(controller, animated: true)
        print("tocou")
    }
}

class MyTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add labels to cell
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        // Configure labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Set constraints for labels
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
