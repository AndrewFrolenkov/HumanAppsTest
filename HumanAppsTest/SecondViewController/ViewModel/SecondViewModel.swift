//
//  SecondViewModel.swift
//  HumanAppsTest
//
//  Created by Андрей Фроленков on 1.04.24.
//

import Foundation

protocol SettingsDelegate: AnyObject {
    func reloadData()
}

// ViewModel для экрана Настроек
protocol SettingsViewModelProtocol {
    var delegate: SettingsDelegate? { get set }
    var settingsData: [AboutCellData] { get }
    func addPersonalInfo(firstName: String, lastName: String)
}

class SecondViewModel: SettingsViewModelProtocol {

    weak var delegate: SettingsDelegate?
    var settingsData: [AboutCellData]

    init() {
        self.settingsData = [AboutCellData(title: "About the App")]
    }
  
  func addPersonalInfo(firstName: String, lastName: String) {
        let fullName = "\(firstName) \(lastName)"
        let personalInfoCell = AboutCellData(title: fullName)
        settingsData.append(personalInfoCell)
        delegate?.reloadData()
    }
  
}
