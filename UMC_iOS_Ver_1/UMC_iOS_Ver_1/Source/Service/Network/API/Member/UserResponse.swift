//
//  UserResponse.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/05/06.
//

import Foundation

struct UserResponse: Decodable {
    var nickName: String?
    var imageUrl: String?
    var introduction: String
    var tier: String
}
