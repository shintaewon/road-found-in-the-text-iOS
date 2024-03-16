//
//  ScriptListResonse.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/11.
//

import Foundation

struct ScriptListResonse: Codable {
    let result: String
    let scripts: [ScriptResponse]
    let count: Int
}
