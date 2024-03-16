//
//  NicknameInputReactor.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/18.
//

import ReactorKit

final class NicknameInputReactor: Reactor {
    private let networkService: NetworkServiceType

    enum NicknameValid {
        case valid
        case duplicate
        case rangeOver
    }

    enum Action {
        case editNickname(String?)
        case tapAgreeAll
        case tapAgreeTerms
        case tapAgreePrivacy
        case tapComplete
    }

    enum Mutation {
        case setNickname(String?)
        case setAgreeAll(Bool)
        case setAgreeTerms(Bool)
        case setAgreePrivacy(Bool)
        case setNicknameValid(NicknameValid?)
        case setIsShowNextPage(Bool)
    }

    struct State {
        var nickname: String?
        var agreeAll: Bool
        var agreeTerms: Bool
        var agreePrivacy: Bool
        var nicknameValid: NicknameValid?
        var isShowNextPage: Bool
    }

    let initialState: State

    init(networkService: NetworkServiceType = NetworkService.shared) {
        initialState = State(
            nickname: nil,
            agreeAll: false,
            agreeTerms: false,
            agreePrivacy: false,
            nicknameValid: nil,
            isShowNextPage: false
        )

        self.networkService = networkService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .editNickname(let nickname):
            guard let nickname = nickname,
                  nickname.count > 1 && nickname.count < 30 else {
                return .just(.setNicknameValid(.rangeOver))
            }
            return .just(.setNickname(nickname))
        case .tapAgreeAll:
            return .just(.setAgreeAll(!currentState.agreeAll))
        case .tapAgreeTerms:
            return .just(.setAgreeTerms(!currentState.agreeTerms))
        case .tapAgreePrivacy:
            return .just(.setAgreePrivacy(!currentState.agreePrivacy))
        case .tapComplete:
            guard let nickname = currentState.nickname else { return .empty() }
            return networkService.nicknameAPI.setNickname(nickname: nickname)
                .andThen(Observable.just(Void()))
                .flatMap { _ -> Observable<Mutation> in
                    UserDefaultStorageService.shared.nickname = nickname
                    return .just(.setIsShowNextPage(true))
                }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setNickname(let nickname):
            state.nickname = nickname
        case .setNicknameValid(let valid):
            state.nicknameValid = valid
        case .setAgreeAll(let agree):
            state.agreeAll = agree
            state.agreeTerms = agree
            state.agreePrivacy = agree
        case .setAgreeTerms(let agree):
            state.agreeTerms = agree
        case .setAgreePrivacy(let agree):
            state.agreePrivacy = agree
        case .setIsShowNextPage(let isShow):
            state.isShowNextPage = isShow
        }
        return state
    }
}
