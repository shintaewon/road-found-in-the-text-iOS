//
//  MyPageTableViewCell.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/07/10.
//

import UIKit

import SnapKit

class MyPageTableViewCell: UITableViewCell {
    
    static let identifier = "MyPageCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.textColor = .mainTextColor
        
        return label
    }()
    
    var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.setImageColor(color: .sub2)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }

}

extension MyPageTableViewCell {
    private func setup() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(chevronImageView)
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func styleDeleteAccount() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.subTextColor,
            .underlineStyle: 1,
            .underlineColor: UIColor.subTextColor
        ]
        
        let attributedString = NSAttributedString(string: "계정탈퇴", attributes: attributes)
        
        titleLabel.text = ""
        titleLabel.attributedText = attributedString
    }
}
