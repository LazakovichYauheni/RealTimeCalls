//
//  UserService.swift
//  WaveForm
//
//  Created by Doctor Kocte on 5.06.23.
//

import Foundation
import Alamofire

public protocol UserServiceProtocol {
    //func getUsers(completion: @escaping (Result<[User], NSError>) -> Void)
    func register(
        idToken: String,
        completion: @escaping (Result<Void, UIError>) -> Void
    )
    func register(
        username: String,
        password: String,
        phoneNumber: String,
        firstName: String?,
        lastName: String?,
        completion: @escaping (Result<Void, UIError>) -> Void
    )
    func login(userName: String, password: String, completion: @escaping (Result<Void, UIError>) -> Void)
    func login(
        idToken: String,
        completion: @escaping (Result<Void, UIError>) -> Void
    )
    func getUserData(completion: @escaping (Result<User, UIError>) -> Void)
    func checkUser(username: String, completion: @escaping (Result<InvitableUsers, UIError>) -> Void)
    func addContact(username: String, completion: @escaping (Result<String, UIError>) -> Void)
    func changeProfileImage(string: String, completion: @escaping (Result<Void, UIError>) -> Void)
    func addToFavorites(username: String, completion: @escaping (Result<Void, UIError>) -> Void)
}

public class UserService: UserServiceProtocol {
    private let requestManager: RequestManager
    private let endpointConfig: EndpointConfig

    init(requestManager: RequestManager, endpointConfig: EndpointConfig) {
        self.requestManager = requestManager
        self.endpointConfig = endpointConfig
    }
    
//    public func getUsers(completion: @escaping (Result<[User], NSError>) -> Void) {
//        requestManager.exec(
//            ofType: [UserDTO].self,
//            baseURL: endpointConfig.usersEndpoint,
//            method: .get
//        ) { result in
//            switch result {
//            case let .success(dto):
//                let users = dto.compactMap { User(dto: $0) }
//                completion(.success(users))
//
//            case let .failure(error):
//                completion(.failure(error as NSError))
//            }
//        }
//    }
    
    public func register(
        idToken: String,
        completion: @escaping (Result<Void, UIError>) -> Void
    ) {
        let parameters = [
            "tokenId": idToken
        ]
        
        requestManager.request(
            baseURL: endpointConfig.registerByGoogleEndpoint,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<TokenDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    let tokenModel = Token(dto: dto.data)
                    KeychainHelper.shared.save(Data(tokenModel.accessToken.utf8), service: "accessToken")
                    KeychainHelper.shared.save(Data(tokenModel.refreshToken.utf8), service: "refreshToken")
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func register(
        username: String,
        password: String,
        phoneNumber: String,
        firstName: String?,
        lastName: String?,
        completion: @escaping (Result<Void, UIError>) -> Void
    ) {
        let parameters = [
            "username": username,
            "password": password,
            "phoneNumber": phoneNumber,
            "firstName": firstName,
            "lastName": lastName
        ]

        requestManager.request(
            baseURL: endpointConfig.registrationEndpoint,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<TokenDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    let tokenModel = Token(dto: dto.data)
                    KeychainHelper.shared.save(Data(tokenModel.accessToken.utf8), service: "accessToken")
                    KeychainHelper.shared.save(Data(tokenModel.refreshToken.utf8), service: "refreshToken")
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func login(
        idToken: String,
        completion: @escaping (Result<Void, UIError>) -> Void
    ) {
        let parameters = [
            "tokenId": idToken
        ]
        
        requestManager.request(
            baseURL: endpointConfig.loginByGoogleEndpoint,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<TokenDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    let tokenModel = Token(dto: dto.data)
                    KeychainHelper.shared.save(Data(tokenModel.accessToken.utf8), service: "accessToken")
                    KeychainHelper.shared.save(Data(tokenModel.refreshToken.utf8), service: "refreshToken")
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func login(
        userName: String,
        password: String,
        completion: @escaping (Result<Void, UIError>) -> Void
    ) {
        let parameters = [
            "username": userName,
            "password": password
        ]

        requestManager.request(
            baseURL: endpointConfig.loginEndpoint,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<TokenDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    let tokenModel = Token(dto: dto.data)
                    KeychainHelper.shared.save(Data(tokenModel.accessToken.utf8), service: "accessToken")
                    KeychainHelper.shared.save(Data(tokenModel.refreshToken.utf8), service: "refreshToken")
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func getUserData(completion: @escaping (Result<User, UIError>) -> Void) {
        guard
            let data = KeychainHelper.shared.read(service: "accessToken"),
            let token = String(data: data, encoding: .utf8)
        else {
            completion(.failure(.emptyPath))
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]

        requestManager.request(
            baseURL: endpointConfig.getUserDataEndpoint,
            headers: headers,
            parameters: [:],
            method: .get,
            completion: { (result: Result<ApiResponseDTO<UserDataDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    completion(.success(UserData(dto: dto.data).user))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func checkUser(username: String, completion: @escaping (Result<InvitableUsers, UIError>) -> Void) {
        guard
            let data = KeychainHelper.shared.read(service: "accessToken"),
            let token = String(data: data, encoding: .utf8)
        else {
            completion(.failure(.emptyPath))
            return
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]
        
        requestManager.request(
            baseURL: endpointConfig.checkUserEndpoint + "?searchText=\(username)",
            headers: headers,
            parameters: [:],
            method: .get,
            completion: { (result: Result<ApiResponseDTO<InvitableUsersDTO>, UIError>) in
                switch result {
                case let .success(dto):
                    completion(.success(InvitableUsers(dto: dto.data)))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func addContact(username: String, completion: @escaping (Result<String, UIError>) -> Void) {
        guard
            let data = KeychainHelper.shared.read(service: "accessToken"),
            let token = String(data: data, encoding: .utf8)
        else {
            completion(.failure(.emptyPath))
            return
        }

        let parameters = [
            "username": username
        ]

        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]

        requestManager.request(
            baseURL: endpointConfig.addContactEndpoint,
            headers: headers,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<String>, UIError>) in
                switch result {
                case let .success(dto):
                    completion(.success(dto.data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func changeProfileImage(string: String, completion: @escaping (Result<Void, UIError>) -> Void) {
        guard
            let data = KeychainHelper.shared.read(service: "accessToken"),
            let token = String(data: data, encoding: .utf8)
        else {
            completion(.failure(.emptyPath))
            return
        }

        let parameters = [
            "imageString": string
        ]

        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]

        requestManager.request(
            baseURL: endpointConfig.changeProfileImageEndpoint,
            headers: headers,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<ApiResponseDTO<String>, UIError>) in
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func addToFavorites(username: String, completion: @escaping (Result<Void, UIError>) -> Void) {
        guard
            let data = KeychainHelper.shared.read(service: "accessToken"),
            let token = String(data: data, encoding: .utf8)
        else {
            completion(.failure(.emptyPath))
            return
        }

        let parameters = [
            "username": username
        ]

        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]

        requestManager.request(
            baseURL: endpointConfig.addToFavoritesEndpoint,
            headers: headers,
            parameters: parameters,
            method: .post,
            encoding: JSONEncoding.default,
            completion: { (result: Result<SuccessResponseDTO, UIError>) in
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
}
