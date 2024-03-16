//
//  ScriptResponse.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/11.
//

import Foundation

struct ScriptResponse: Codable {
    let scriptId: Int
    let scriptTitle: String
    let content: String
    let countPage: Int
    let modifiedDate: String
    
    enum CodingKeys: String, CodingKey {
        case scriptId = "script_id"
        case scriptTitle = "script_title"
        case content
        case countPage = "count_page"
        case modifiedDate = "modified_date"
    }
}
