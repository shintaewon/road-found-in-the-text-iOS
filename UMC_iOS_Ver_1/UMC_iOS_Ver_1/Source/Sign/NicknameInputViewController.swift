//
//  NicknameInputViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/18.
//

import UIKit
import ReactorKit

enum AgreeCheckBoxType {
    case terms
    case privacy

    var title: String {
        switch self {
        case .terms:
            return "이용약관"
        case .privacy:
            return "개인정보 처리방침"
        }
    }

    var path: String {
        switch self {
        case .terms:
            return "https://animated-rover-f41.notion.site/e8fda0f340754861968588910d9e22f8"
        case .privacy:
            return "https://animated-rover-f41.notion.site/7e6a1f7ef6354143b75a41a81bd054e5"
        }
    }
}

final class NicknameInputViewController: UIViewController, View {
    typealias Reactor = NicknameInputReactor

    enum Metric {
        static let titleTopPadding: CGFloat = 40
        static let titleLeading: CGFloat = 16
        static let subTitleTopPadding: CGFloat = 30
        static let subTitleLeading: CGFloat = 24
        static let textFieldTopPadding: CGFloat = 4
        static let textFieldHeight: CGFloat = 46
        static let buttonBottomPadding: CGFloat = -52
    }

    let naviBar = CommonNaviBar(title: "닉네임 설정", type: .back)
    let nicknameTextField = UITextField()
    let completeButton = BottomButton()
    let agreeAllCheckBox = AgreeCheckBox(title: "", type: .all)
    let agreeTermsCheckBox = AgreeCheckBox(title: "이용약관 동의", type: .essential)
    let agreePrivacyCheckBox = AgreeCheckBox(title: "개인정보 수집 및 이용동의", type: .essential)

    var disposeBag = DisposeBag()

    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("[View Did Load] Nickname Input View Controller")
        setUp()
    }

    func bind(reactor: Reactor) {
        naviBar.rx.tapBackButton
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        nicknameTextField.rx.text
            .map { Reactor.Action.editNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        agreeAllCheckBox.rx.tapAgree
            .map { Reactor.Action.tapAgreeAll }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeTermsCheckBox.rx.tapAgree
            .map { Reactor.Action.tapAgreeTerms }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        agreeTermsCheckBox.rx.tapMore
            .subscribe(onNext: { [weak self] _ in
                self?.showWebView(by: .terms)
            })
            .disposed(by: disposeBag)
        
        agreePrivacyCheckBox.rx.tapAgree
            .map { Reactor.Action.tapAgreePrivacy }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        agreePrivacyCheckBox.rx.tapMore
            .subscribe(onNext: { [weak self] _ in
                self?.showWebView(by: .privacy)
            })
            .disposed(by: disposeBag)
    
        completeButton.rx.tap
            .map { Reactor.Action.tapComplete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.agreeAll }
            .bind(to: agreeAllCheckBox.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state.map { $0.agreeTerms }
            .bind(to: agreeTermsCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.agreePrivacy }
            .bind(to: agreePrivacyCheckBox.rx.isSelected)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.agreePrivacy }.distinctUntilChanged(),
            reactor.state.map { $0.agreeTerms }.distinctUntilChanged(),
            reactor.state.map { $0.nickname }.distinctUntilChanged().map { $0?.count ?? 0 }
        )
            .map { $0 && $1 && $2 > 1 && $2 < 30 }
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isShowNextPage }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] isShow in
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    private func showWebView(by type: AgreeCheckBoxType) {

        navigationController?.pushViewController(WebViewController(title: type.title, urlPath: type.path), animated: false)
    }
}

extension NicknameInputViewController {
    private func setUp() {
        view.backgroundColor = .white
        view.addSubview(naviBar)

        naviBar.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.height.equalTo(44)
        }

        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .mainTextColor
        titleLabel.text = "환영합니다!\n닉네임을 입력해주세요."
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(naviBar.snp.bottom).offset(Metric.titleTopPadding)
            maker.leading.trailing.equalToSuperview().inset(Metric.titleLeading)
        }

        let subTitleLabel = UILabel()
        subTitleLabel.textColor = .subTextColor
        subTitleLabel.text = "닉네임"
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        view.addSubview(subTitleLabel)

        subTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(Metric.subTitleTopPadding)
            maker.leading.trailing.equalToSuperview().inset(Metric.subTitleLeading)
        }

        let textField = nicknameTextField
        textField.textColor = .mainTextColor
        textField.font = .systemFont(ofSize: 14, weight: .regular)
        textField.borderStyle = .roundedRect
        view.addSubview(textField)

        textField.snp.makeConstraints { maker in
            maker.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.textFieldTopPadding)
            maker.leading.trailing.equalTo(titleLabel)
            maker.height.equalTo(Metric.textFieldHeight)
        }

        let completeButton = completeButton
        view.addSubview(completeButton)

        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(Metric.buttonBottomPadding)
        }
    
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(completeButton.snp.top).offset(-Metric.titleTopPadding)
        }

        let grayLine = UIView()
        grayLine.backgroundColor = .sub4

        stackView.addArrangedSubview(agreeAllCheckBox)
        stackView.addArrangedSubview(grayLine)
        stackView.addArrangedSubview(agreeTermsCheckBox)
        stackView.addArrangedSubview(agreePrivacyCheckBox)

        grayLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
}
