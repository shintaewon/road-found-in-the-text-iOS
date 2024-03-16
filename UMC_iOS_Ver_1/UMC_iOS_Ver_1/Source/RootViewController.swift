//
//  RootViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/14.
//

import UIKit
import RxSwift

final class RootViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        print("[View Did Load] Root View Controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkIsNewUser()
    }

    private func showMainTabbar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mainTabbar")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private func showSign() {
        let signVC = SignViewController(reactor: SignReactor())
        let naviC = UINavigationController(rootViewController: signVC)
        naviC.modalPresentationStyle = .fullScreen
        naviC.isNavigationBarHidden = true
        present(naviC, animated: false)
    }

    private func checkIsNewUser() {
        // FIXME: Token 제거
        //TokenStorageService.shared.deleteToken()
        // 로그인 정보(Nickname)가 있으면 메인 없으면 로그인
        NetworkService.shared.memberAPI.fetchUser()
            .subscribe(onSuccess: { [weak self] user in
                guard let nickname = user.nickName else {
                    self?.showSign()
                    return
                }
                UserDefaultStorageService.shared.nickname = nickname
                self?.showMainTabbar()
            }, onFailure: { [weak self] error in
                self?.showSign()
            })
            .disposed(by: disposeBag)
    }
}
