//
//  NicknameAPI.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/07/20.
//

import Moya
import RxSwift

enum NicknameTarget {
    case postNickname(request: NicknameRequest)
}

extension NicknameTarget: BaseTargetType, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .postNickname:
            return "/api/v1/members/nickname"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case .postNickname(let request):
            return .requestJSONEncodable(request)
        }
    }

    var authorizationType: AuthorizationType? {
        return .bearer
    }
}

struct NicknameAPI: Networkable {
    typealias Target = NicknameTarget

    func setNickname(nickname: String) -> Completable {
        return Completable.create { completable -> Disposable in
            makeProvider().request(.postNickname(request: NicknameRequest(nickname: nickname))) { result in
                switch result {
                case .success:
                    completable(.completed)
                case let .failure(error):
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
