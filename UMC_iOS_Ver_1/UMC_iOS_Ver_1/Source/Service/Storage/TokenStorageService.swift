//
//  TokenStorageService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/05/03.
//

import Foundation

protocol TokenStorageServiceType {
    func updateToken(accessToken: String, refreshToken: String?)
    func readToken() -> (accessToken: String?, refreshToken: String?)
}

final class TokenStorageService: TokenStorageServiceType {
    static let shared = TokenStorageService()

    private let keychainService: KeychainServiceType

    private init(keychainService: KeychainServiceType = KeychainService.shared) {
        self.keychainService = keychainService
    }

    func updateToken(accessToken: String, refreshToken: String?) {
        keychainService.create(key: "accessToken", token: accessToken)
        keychainService.create(key: "refreshToken", token: refreshToken)
    }

    func readToken() -> (accessToken: String?, refreshToken: String?) {
        return (keychainService.read(key: "accessToken"), keychainService.read(key: "refreshToken"))
    }

    func deleteToken() {
        keychainService.delete(key: "accessToken")
        keychainService.delete(key: "refreshToken")
    }
}
