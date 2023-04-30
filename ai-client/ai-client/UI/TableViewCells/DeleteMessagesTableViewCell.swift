//
//  DeleteMessagesTableViewCell.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit
import SPIndicator

class DeleteMessagesTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Delete all messages"
        return label
    }()
    
    let clearButton: UIButton = {
        let button = UIButton()
        let configuration = UIButton.Configuration.tinted()
        button.configuration = configuration
        button.tintColor = UIColor.systemPurple
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(deleteMessagesAction), for: .touchUpInside)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set() {
        setupLayout()
        setupConstraints()
    }
    
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(clearButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc private func deleteMessagesAction(_ sender: UIButton) {
        RealmManager<RealmMessageModel>().read().forEach { message in
            RealmManager<RealmMessageModel>().delete(object: message)
        }
        
        SPIndicator.present(title: "Success", message: "Messages deleted", preset: .done, haptic: .success, from: .top)
    }
}
