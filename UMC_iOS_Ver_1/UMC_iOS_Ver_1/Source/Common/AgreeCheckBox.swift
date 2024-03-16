//
//  AgreeCheckBox.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/19.
//

import UIKit
import RxSwift
import RxCocoa

final class AgreeCheckBox: UIView {
    enum AgreeTitleType {
        case all
        case essential
    }

    let checkBoxButton = UIButton()
    let titleLabel = UILabel()
    let moreButton = UIButton()

    init(title: String, type: AgreeTitleType) {
        super.init(frame: .zero)

        setUp(title: title, type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(title: String, type: AgreeTitleType) {
        let checkBox = checkBoxButton
        checkBox.setImage(UIImage(named: "ic_check_unselected"), for: .normal)
        checkBox.setImage(UIImage(named: "ic_check_selected"), for: .selected)
        addSubview(checkBox)

        checkBox.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(24)
        }

        let moreButton = moreButton
        moreButton.setImage(UIImage(named: "ic_Detail"), for: .normal)
        moreButton.isHidden = type == .all
        addSubview(moreButton)

        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }

        let titleLabel = titleLabel
        switch type {
        case .all:
            titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
            titleLabel.textColor = .mainTextColor
            titleLabel.text = "전체 동의"
        case .essential:
            let attributedString = NSMutableAttributedString(
                string: "[필수]",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                    .foregroundColor: UIColor.mainTextColor
                ])
            let titleString = NSAttributedString(
                string: title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                    .foregroundColor: UIColor.mainTextColor
                ]
            )
            attributedString.append(titleString)
            titleLabel.attributedText = attributedString
        }
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(13)
            make.leading.equalTo(checkBox.snp.trailing).offset(10)
            make.trailing.equalTo(moreButton.snp.leading)
        }
    }
}

extension Reactive where Base: AgreeCheckBox {
    var tapAgree: Observable<Void> {
        return base.checkBoxButton.rx.tap.asObservable()
    }

    var tapMore: Observable<Void> {
        return base.moreButton.rx.tap.asObservable()
    }

    var isSelected: Binder<Bool> {
        return Binder(base) { base, isSelected in
            base.checkBoxButton.isSelected = isSelected
        }
    }
}
