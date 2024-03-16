//
//  SignReactor.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/17.
//

import ReactorKit
import Foundation

final class SignReactor: Reactor {
    private let kakaoLoginService: KakaoAuthServiceType
    private let networkService: NetworkServiceType
    private let tokenStorageService: TokenStorageServiceType

    enum Action {
        case loginKakao
        case loginApple(String?)
    }

    enum Mutation {
        case setIsNewMember(Bool)
    }

    struct State {
        var isNewMember: Bool?
    }

    let initialState: State

    init(kakaoLoginService: KakaoAuthServiceType = KakaoAuthService.shared,
         networkService: NetworkServiceType = NetworkService.shared,
         tokenStorageService: TokenStorageServiceType = TokenStorageService.shared
    ) {
        initialState = State(isNewMember: nil)

        self.kakaoLoginService = kakaoLoginService
        self.networkService = networkService
        self.tokenStorageService = tokenStorageService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loginKakao:
            return signInKakao()
                .flatMap { response -> Observable<Mutation> in
                    return .just(.setIsNewMember(!response.userSettingDone))
                }
        case .loginApple(let id):
            guard let id = id else { return .empty() }
            return signInApple(token: id)
                .flatMap { response -> Observable<Mutation> in
                    return .just(.setIsNewMember(!response.userSettingDone))
                }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIsNewMember(let isNewMember):
            state.isNewMember = isNewMember
        }
        return state
    }

    private func signInKakao() -> Observable<SignResponse> {
        return kakaoLoginService.requestToken()
            .asObservable()
            .flatMap { [weak self] oauthToken -> Observable<SignResponse> in
                guard let ss = self else { return .empty() }
                let request = SignRequest(accessToken: oauthToken, loginType: SignRequest.loginTypeKAKAO)
                return ss.networkService.signAPI.fetchSignIn(request: request)
                    .asObservable()
            }
            .do(onNext: { [weak self] response in
                self?.tokenStorageService.updateToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            })
    }

    private func signInApple(token: String) -> Observable<SignResponse> {
        let request = SignRequest(accessToken: token, loginType: SignRequest.loginTypeAPPLE)
        return networkService.signAPI.fetchSignIn(request: request)
            .asObservable()
            .do(onNext: { [weak self] response in
                self?.tokenStorageService.updateToken(accessToken: response.accessToken, refreshToken: response.refreshToken)
            })
    }
}
