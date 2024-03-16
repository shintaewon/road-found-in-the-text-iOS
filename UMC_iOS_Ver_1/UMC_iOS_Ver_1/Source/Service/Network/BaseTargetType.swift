//
//  BaseTargetType.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        URL(string: NetworkService.baseURL)!
    }

    var headers: [String : String]? {
        [
            "Content-type": "application/json",
        ]
    }
}
