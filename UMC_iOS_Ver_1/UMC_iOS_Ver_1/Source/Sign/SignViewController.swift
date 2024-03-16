//
//  SignViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import KakaoSDKUser
import ReactorKit

final class SignViewController: UIViewController, View {

    typealias Reactor = SignReactor

    enum Metric {
        static let subTitleTopInset: CGFloat = 130
        static let subTitleLeadingInset: CGFloat = 16
        static let signButtonHorizontalInset: CGFloat = 38
        static let signButtonBottomInset: CGFloat = 135
        static let signButtonHeight: CGFloat = 45
        static let descriptionOffset: CGFloat = -16
    }

    let kakaoSignButton = UIButton()
    let appleSignButton = AppleLoginButton()

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
        
        print("[View Did Load] Sign View Controller")
        setUp()
    }

    func bind(reactor: Reactor) {
        kakaoSignButton.rx.tap
            .map { Reactor.Action.loginKakao }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        appleSignButton.rx.loginOnTap()
            .map { Reactor.Action.loginApple($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isNewMember }
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] isNewMember in
                guard isNewMember ?? false else {
                    self?.showMainTabbar()
                    return
                }
                self?.showNicknameInput()
            })
            .disposed(by: disposeBag)
    }

    private func showMainTabbar() {
        NetworkService.shared.memberAPI.fetchUser()
            .subscribe(onSuccess: { [weak self] user in
                guard let nickname = user.nickName else { return }
                UserDefaultStorageService.shared.nickname = nickname
                self?.navigationController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
    }

    private func showNicknameInput() {
        let nicknameInputVC = NicknameInputViewController(reactor: NicknameInputReactor())
        navigationController?.pushViewController(nicknameInputVC, animated: true)
    }
}

extension SignViewController {
    private func setUp() {
        view.backgroundColor = .white

        let subTitle = UILabel()
        subTitle.numberOfLines = 2
        subTitle.font = .systemFont(ofSize: 16, weight: .regular)
        subTitle.textColor = .mainTextColor
        subTitle.text = "내가 하고 싶은 말,\n온전히 전달할 수 있을 때까지"
        view.addSubview(subTitle)

        subTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.subTitleTopInset)
            make.leading.equalToSuperview().inset(Metric.subTitleLeadingInset)
        }

        let logo = UIImageView()
        logo.image = UIImage(named: "sign_logo")
        view.addSubview(logo)

        logo.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom).offset(10)
            make.leading.equalTo(subTitle)
        }

        let signButtonList = UIStackView()
        signButtonList.axis = .vertical
        signButtonList.spacing = 10
        view.addSubview(signButtonList)
        
        signButtonList.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.signButtonBottomInset)
            make.width.equalTo(300)
        }

        let kakaoButton = kakaoSignButton
        kakaoButton.setImage(UIImage(named: "btn_login_kakao"), for: .normal)
        signButtonList.addArrangedSubview(kakaoButton)
        
        kakaoButton.snp.makeConstraints { make in
            make.height.equalTo(Metric.signButtonHeight)
        }

        let appleButton = appleSignButton
        appleButton.setImage(UIImage(named: "btn_login_apple"), for: .normal)
        signButtonList.addArrangedSubview(appleButton)

        appleButton.snp.makeConstraints { make in
            make.height.equalTo(Metric.signButtonHeight)
        }

        let descriptionLabel = UILabel()
        descriptionLabel.text = "먼저, 로그인이 필요해요 :)"
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .subTextColor
        view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(signButtonList)
            make.bottom.equalTo(signButtonList.snp.top).offset(Metric.descriptionOffset)
        }
    }
}
