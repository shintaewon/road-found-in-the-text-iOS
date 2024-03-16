//
//  MemberAPI.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/05/04.
//

import Moya
import RxSwift

enum MemberTarget {
    case getMember
}

extension MemberTarget: BaseTargetType, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .getMember:
            return "/api/v1/members/mypage"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        case .getMember:
            return .requestPlain
        }
    }

    var authorizationType: AuthorizationType? {
        return .bearer
    }
}

struct MemeberAPI: Networkable {
    typealias Target = MemberTarget

    func fetchUser() -> Single<UserResponse> {
        return Single.create { single -> Disposable in
            makeProvider().request(.getMember) { result in
                switch result {
                case let .success(model):
                    do {
                        let response = try model.map(UserResponse.self)
                        single(.success(response))
                    } catch {
                        single(.failure(error))
                    }
                case let .failure(error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
