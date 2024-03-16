//
//  WebViewController.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/05/05.
//

import UIKit
import WebKit
import RxSwift

class WebViewController: UIViewController {
    let naviBar: CommonNaviBar
    let webView = WKWebView()

    private let urlPath: String
    let disposeBag = DisposeBag()

    init(title: String, urlPath: String) {
        naviBar = CommonNaviBar(title: title, type: .back)
        self.urlPath = urlPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        setUpWebView()
        bind()
    }

    private func setUpWebView() {
        guard let url = URL(string: urlPath) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func bind() {
        naviBar.rx.tapBackButton
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension WebViewController {
    private func setUp() {
        view.backgroundColor = .white
        view.addSubview(naviBar)

        naviBar.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.height.equalTo(44)
        }

        view.addSubview(webView)

        webView.snp.makeConstraints { maker in
            maker.top.equalTo(naviBar.snp.bottom)
            maker.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
