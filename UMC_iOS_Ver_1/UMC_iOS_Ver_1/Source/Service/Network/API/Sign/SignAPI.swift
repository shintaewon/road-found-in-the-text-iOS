//
//  SignAPI.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Moya
import RxSwift

enum SignTarget {
    case signIn(request: SignRequest)
}

extension SignTarget: BaseTargetType {
    var path: String {
        switch self {
        case .signIn:
            return "/api/v1/auth/login"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case .signIn(let request):
            return .requestJSONEncodable(request)
        }
    }
}

struct SignAPI: Networkable {
    typealias Target = SignTarget

    func fetchSignIn(request: SignRequest) -> Single<SignResponse> {
        return Single.create { single -> Disposable in
            makeProvider().request(.signIn(request: request)) { result in
                switch result {
                case let .success(model):
                    do {
                        let response = try model.map(SignResponse.self)
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
