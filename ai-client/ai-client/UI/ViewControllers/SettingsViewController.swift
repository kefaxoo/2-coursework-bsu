//
//  SettingsViewController.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, DeleteMessagesTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    private func setupInterface() {
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.tintColor = UIColor.systemPurple
        setupLayout()
        setupConstraints()
    }
    
    private func setupLayout() {
        self.view.addSubview(settingsTableView)
    }
    
    private func setupConstraints() {
        settingsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id: String = {
            if indexPath.row < 2 {
                return SettingTableViewCell.id
            } else {
                return DeleteMessagesTableViewCell.id
            }
        }()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        if indexPath.row < 2 {
            guard let settingCell = cell as? SettingTableViewCell else { return cell }
            
            settingCell.set(type: SettingsType.allCases[indexPath.row])
            return settingCell
        } else {
            guard let deleteCell = cell as? DeleteMessagesTableViewCell else { return cell }
            
            deleteCell.set()
            return deleteCell
        }
    }
}
