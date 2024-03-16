//
//  MyPageService.swift
//  UMC_iOS_Ver_1
//
//  Created by 이서영 on 2023/08/08.
//

import Foundation

import Alamofire

class MyPageService {
    static func getMemberInfo(completion: @escaping (MemberResponse) -> Void) {
        let url = Constant.BASE_URL + Constant.MEMBER + "mypage"
        
        guard let token = TokenStorageService.shared.readToken().accessToken else {
            assert(false)
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MemberResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    debugPrint(error)
                }
            }        
    }
    
    static func putMemberProfile(profile: MemberProfile, completion: @escaping (MemberProfileResponse) -> Void) {
        let url = Constant.BASE_URL + Constant.MEMBER + "profile"
        
        guard let token = TokenStorageService.shared.readToken().accessToken else {
            assert(false)
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .put, parameters: profile, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: MemberProfileResponse.self) { response in
                switch response.result {
                case .success(let response):
                    completion(response)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
}
