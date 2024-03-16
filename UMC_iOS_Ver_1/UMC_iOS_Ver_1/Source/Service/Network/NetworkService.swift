//
//  NetworkService.swift
//  UMC_iOS_Ver_1
//
//  Created by DONGGUN LEE on 2023/04/15.
//

import Moya

enum NetworkError: Error {
    case decodingError
    case nilResponse
    case nilData
    case clientError
    case serverError
}

protocol NetworkServiceType {
    var signAPI: SignAPI { get }
    var nicknameAPI: NicknameAPI { get }
    var memberAPI: MemeberAPI { get }
}

final class NetworkService: NetworkServiceType {
    static let shared = NetworkService()
    static let baseURL = Constant.BASE_URL

    private init() { }
}

extension NetworkService {
    var signAPI: SignAPI { SignAPI() }
    var nicknameAPI: NicknameAPI { NicknameAPI() }
    var memberAPI: MemeberAPI { MemeberAPI() }
}
