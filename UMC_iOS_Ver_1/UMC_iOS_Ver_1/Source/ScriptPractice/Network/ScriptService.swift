//
//  ScriptService.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/11.
//

import Foundation

import Alamofire

class ScriptService {
    static func getUserAllScript(completion: @escaping (ScriptListResonse) -> Void) {
        let url = Constant.BASE_URL + Constant.SCRIPT + "all/me"
        
        guard let token = TokenStorageService.shared.readToken().accessToken else {
            assert(false)
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: ScriptListResonse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
}
