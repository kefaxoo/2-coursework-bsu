//
//  MainViewController.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    lazy var vcTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VCTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    private func setupInterface() {
        setupLayout()
        setupConstraints()
        self.view.backgroundColor = UIColor.systemBackground
    }
    
    private func setupLayout() {
        self.view.addSubview(vcTableView)
    }
    
    private func setupConstraints() {
        vcTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.id, for: indexPath)
        guard let vcCell = cell as? VCTableViewCell else { return cell }
        
        vcCell.set(type: VCType.allCases[indexPath.row])
        return vcCell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(VCType.allCases[indexPath.row].vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
