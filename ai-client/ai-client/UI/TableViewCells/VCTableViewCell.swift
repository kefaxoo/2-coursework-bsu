//
//  VCTableViewCell.swift
//  ai-client
//
//  Created by Bahdan Piatrouski on 30.04.23.
//

import UIKit

class VCTableViewCell: UITableViewCell {

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var spacerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()
    
    private var type: VCType = .chat
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(type: VCType) {
        setupLayout()
        setupConstraints()
        iconImageView.image = type.icon
        titleLabel.text = type.rawValue
    }
    
    private func setupLayout() {
        self.contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(iconImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(25)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
    }
}
