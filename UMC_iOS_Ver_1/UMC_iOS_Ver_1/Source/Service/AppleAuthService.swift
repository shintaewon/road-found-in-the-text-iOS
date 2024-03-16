//
//  AppleAuthService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/05/02.
//

import RxSwift
import RxCocoa
import AuthenticationServices

extension ASAuthorizationController: HasDelegate {
    public typealias Delegate = ASAuthorizationControllerDelegate
}

class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var presentationWindow: UIWindow = UIWindow()

    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }

    // MARK: - DelegateProxyType
    public static func registerKnownImplementations() {
        register { ASAuthorizationControllerProxy(controller: $0) }
    }

    // MARK: - Proxy Subject
    internal lazy var didComplete = PublishSubject<ASAuthorization>()

    // MARK: - ASAuthorizationControllerDelegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }

    // MARK: - Completed
    deinit {
        self.didComplete.onCompleted()
    }
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    public func login(scope: [ASAuthorization.Scope]? = nil, on window: UIWindow) -> Observable<ASAuthorization> {
        let request = base.createRequest()
        request.requestedScopes = scope

        let controller = ASAuthorizationController(authorizationRequests: [request])

        let proxy = ASAuthorizationControllerProxy.proxy(for: controller)
        proxy.presentationWindow = window

        controller.presentationContextProvider = proxy
        controller.performRequests()

        return proxy.didComplete
    }
}

extension Reactive where Base: AppleLoginButton {
    func loginOnTap(scope: [ASAuthorization.Scope]? = nil) -> Observable<String?> {
        return controlEvent(.touchUpInside)
            .flatMap {
                return ASAuthorizationAppleIDProvider().rx.login(scope: scope, on: base.window!)
                    .map { result in
                        guard let auth = result.credential as? ASAuthorizationAppleIDCredential,
                              let token = auth.identityToken else { return nil }
                        return String(data: token, encoding: .utf8)
                    }
            }
    }

    func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        return ASAuthorizationAppleIDProvider().rx.login(scope: scope, on: base.window!)
    }
}
