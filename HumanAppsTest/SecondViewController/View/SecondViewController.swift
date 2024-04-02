//
//  SecondViewController.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
  var viewModel: SettingsViewModelProtocol
  
  lazy var tableView: UITableView = setTableView()
  
  init(viewModel: SettingsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.viewModel.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    view.backgroundColor = .white
  }
  
  private func setTableView() -> UITableView {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    
    return tableView
  }
  
}

// MARK: - UITableViewDataSource
extension SecondViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.settingsData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
    cell.textLabel?.text = viewModel.settingsData[indexPath.row].title
    return cell
  }
  
}

// MARK: - UITableViewDelegate
extension SecondViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let alertController = UIAlertController(title: "Enter Your Name", message: "Please enter your name and surname:", preferredStyle: .alert)
    
    alertController.addTextField { (textField) in
      textField.placeholder = "First Name"
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Last Name"
    }
    
    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      
      guard let firstName = alertController.textFields?.first?.text,
      let lastName = alertController.textFields?.last?.text else { return }
      
      let fullName = "\(firstName) \(lastName)"
      // Здесь вы можете использовать полученное имя и фамилию
      self?.viewModel.addPersonalInfo(firstName: firstName, lastName: lastName)
    }
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
}

extension SecondViewController: SettingsDelegate {
  
  func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}


