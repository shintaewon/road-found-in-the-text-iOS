//
//  Member.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/08.
//

import Foundation

struct MemberResponse: Codable {
    var imageUrl: String?
    var nickName: String?
    var introduction: String?
    var tier: String
}
