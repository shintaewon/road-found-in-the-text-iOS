//
//  SignResponse.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Foundation

struct SignResponse: Decodable {
    var accessToken: String
    var refreshToken: String?
    var isNewMember: Bool
    var userSettingDone: Bool
}
