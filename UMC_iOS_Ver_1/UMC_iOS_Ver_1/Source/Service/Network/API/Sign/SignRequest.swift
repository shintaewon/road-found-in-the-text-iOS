//
//  SignRequest.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Foundation

struct SignRequest: Encodable {
    static let loginTypeKAKAO: String = "KAKAO"
    static let loginTypeAPPLE: String = "APPLE"
    let accessToken: String
    let loginType: String
}
