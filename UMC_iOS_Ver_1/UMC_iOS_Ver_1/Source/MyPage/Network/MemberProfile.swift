//
//  MemberProfile.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/17.
//

import Foundation

struct MemberProfile: Codable {
    let nickname: String
    let introduction: String
}

struct MemberProfileResponse: Codable {
    let nickName: String
    let intro: String
}
