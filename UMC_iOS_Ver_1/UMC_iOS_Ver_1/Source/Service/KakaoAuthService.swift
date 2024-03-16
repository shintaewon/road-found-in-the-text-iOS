//
//  KakaoAuthService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/14.
//

import Foundation
import KakaoSDKUser
import RxSwift

enum AuthError: Error {
    case unknown
    case kakaoNotAvailable
}

protocol KakaoAuthServiceType {
    func getCurrentToken() -> String?
    func requestToken() -> Single<String>
}

final class KakaoAuthService: KakaoAuthServiceType {
    static let shared = KakaoAuthService()

    private var kakaoToken: String?

    func getCurrentToken() -> String? {
        return kakaoToken
    }

    func requestToken() -> Single<String> {
        return Single.create { resolver in
            guard UserApi.isKakaoTalkLoginAvailable() else {
                UserApi.shared.loginWithKakaoAccount { [weak self] token, error in
                    if let error = error {
                        resolver(.failure(error))
                        return
                    }

                    guard let token = token else {
                        resolver(.failure(AuthError.unknown))
                        return
                    }

                    self?.kakaoToken = token.accessToken
                    resolver(.success(token.accessToken))
                }
                return Disposables.create()
            }
            UserApi.shared.loginWithKakaoTalk { [weak self] token, error in
                if let error = error {
                    resolver(.failure(error))
                    return
                }

                guard let token = token else {
                    resolver(.failure(AuthError.unknown))
                    return
                }

                self?.kakaoToken = token.accessToken
                resolver(.success(token.accessToken))
            }
            return Disposables.create()
        }
    }
}
