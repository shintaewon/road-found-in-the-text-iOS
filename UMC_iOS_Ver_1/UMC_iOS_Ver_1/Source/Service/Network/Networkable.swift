//
//  Networkable.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Moya

protocol Networkable {
    associatedtype Target: TargetType
    func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    func makeProvider() -> MoyaProvider<Target> {
        guard let token = TokenStorageService.shared.readToken().accessToken else {
            return MoyaProvider<Target>(plugins: [NetworkLoggerPlugin()])
        }

        let tokenClosure: (TargetType) -> String = { _ in
            return token
        }

        return MoyaProvider<Target>(plugins: [NetworkLoggerPlugin(), AccessTokenPlugin(tokenClosure: tokenClosure)])
    }
}
