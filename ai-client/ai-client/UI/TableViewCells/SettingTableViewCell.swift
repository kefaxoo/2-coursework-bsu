//
//  SettingTableViewCell.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit
import SnapKit
import SPIndicator

class SettingTableViewCell: UITableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.tintColor = UIColor.systemPurple
        return textField
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.tinted()
        button.configuration = configuration
        button.tintColor = UIColor.systemPurple
        button.addTarget(self, action: #selector(saveDataAction), for: .touchUpInside)
        return button
    }()
    
    private var type: SettingsType = .apiKey
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(type: SettingsType) {
        self.selectionStyle = .none
        self.type = type
        setupLayout()
        setupConstraints()
        titleLabel.text = "\(type.rawValue):"
        inputTextField.placeholder = type.placeholder
        saveButton.setTitle("Save \(type.rawValue)", for: .normal)
    }

    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(inputTextField)
        self.contentView.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(31)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
    
    @objc private func saveDataAction(_ sender: UIButton) {
        guard let data = inputTextField.text else { return }
        
        if data.isEmpty {
            SPIndicator.present(title: "\(type.rawValue) is empty", preset: .error, haptic: .error, from: .top)
            return
        }
        
        if type == .apiKey {
            SettingsManager.shared.apiKey = data
        } else if type == .username {
            SettingsManager.shared.senderName = data
        }
        
        SPIndicator.present(title: "Success", message: "\(type.rawValue) saved", preset: .done, haptic: .success, from: .top)
    }
}
