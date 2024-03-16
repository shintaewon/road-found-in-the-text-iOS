//
//  UserDefaultStorageService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/19.
//

import Foundation

protocol UserDefaultStorageServiceType {
    var memberID: String? { get set }
    var nickname: String? { get set }
}

final class UserDefaultStorageService: UserDefaultStorageServiceType {
    static var shared = UserDefaultStorageService()
    
    private init() {}

    @UserDefault(key: "memberID")
    var memberID: String?

    @UserDefault(key: "nickname")
    var nickname: String?
}

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let userDefaults: UserDefaults

    init(userDefault: UserDefaults = .standard, key: String) {
        self.userDefaults = userDefault
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return userDefaults.object(forKey: key) as? T
        }
        set {
            if let newValue = newValue {
                userDefaults.set(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}
