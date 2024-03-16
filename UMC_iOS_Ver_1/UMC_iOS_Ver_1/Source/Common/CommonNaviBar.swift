//
//  CommonNaviBar.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/18.
//

import UIKit
import RxSwift
import RxCocoa

final class CommonNaviBar: UIView {
    enum NaviBackButtonType {
        case back
        case none

        var image: UIImage? {
            switch self {
            case .back:
                return UIImage(named: "ic_guide")
            case .none:
                return nil
            }
        }
    }

    private let titleLabel = UILabel()
    let backButton = UIButton()
    
    var backButtonType: NaviBackButtonType

    init(title: String, type: NaviBackButtonType = .none) {
        self.backButtonType = type
        super.init(frame: .zero)
        
        setUp(titleText: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(titleText: String) {
        let titleLabel = titleLabel
        titleLabel.text = titleText
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }

        let backButton = backButton
        backButton.configuration = .plain()
        backButton.isHidden = backButtonType == .none
        backButton.setImage(backButtonType.image, for: .normal)
        addSubview(backButton)

        backButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(6)
            maker.size.equalTo(44)
        }
    }
}

extension Reactive where Base: CommonNaviBar {
    var tapBackButton: Observable<Void> {
        return base.backButton.rx.tap.asObservable()
    }
}
