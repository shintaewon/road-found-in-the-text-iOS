//
//  BottomButton.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/19.
//

import UIKit
import RxSwift
import RxCocoa

final class BottomButton: UIView {
    fileprivate let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setUp()
    }
    
    convenience init(title: String, isBold: Bool, isBlack: Bool) {
        self.init(frame: .zero)
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: isBold ? .bold : .medium)
        button.backgroundColor = isBlack ? .mainTextColor : .sub4
        button.setTitleColor(isBlack ? .white: .sub2, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let button = button
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 8

        addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }

        updateEnabled(isEnabled: true)
    }

    fileprivate func updateEnabled(isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.backgroundColor = isEnabled ? .mainTextColor : .sub4
        button.setTitleColor(isEnabled ? .white: .sub2, for: .normal)
    }
    
    func addTarget(_ target: Any?, _ action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}

extension Reactive where Base: BottomButton {
    var tap: Observable<Void> {
        return base.button.rx.tap.asObservable()
    }

    var isEnabled: Binder<Bool> {
        return Binder(base) { base, isEnabled in
            base.updateEnabled(isEnabled: isEnabled)
        }
    }
}
