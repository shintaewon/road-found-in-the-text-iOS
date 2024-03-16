//
//  UserSessionService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/20.
//

import Foundation
import RxSwift
import RxCocoa

struct UserSession {
    var accessToken: String?
    var memberInfo: MemberInfo?
}

struct MemberInfo {
//    "blockStatus": 0,
//    "email": "string",
//    "id": 0,
//    "imageUrl": "string",
//    "introduction": "string",
//    "loginType": 0,
//    "memberStatus": 0,
//    "nickName": "string",
//    "socialId": "string",
//    "tier": 0
}

protocol UserSessionServiceType {
    var currentUserSession: UserSession? { get }
    func fetchUserSession() -> Completable
}

final class UserSessionService: UserSessionServiceType {
    static let shared = UserSessionService()

    private let currentUserSessionRelay = BehaviorRelay<UserSession?>(value: nil)
    var currentUserSession: UserSession? {
        currentUserSessionRelay.value
    }

    private init() { }

    func fetchUserSession() -> Completable {
        return Completable.create { completable in
            
            return Disposables.create()
        }
    }
}
