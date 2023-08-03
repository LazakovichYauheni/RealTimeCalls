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
        username: String,
        password: String,
        phoneNumber: String,
        firstName: String?,
        lastName: String?,
        completion: @escaping (Result<Token, UIError>) -> Void
    )
    func login(userName: String, password: String, completion: @escaping (Result<Token, UIError>) -> Void)
    func getUserData(username: String, token: String, completion: @escaping (Result<User, UIError>) -> Void)
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
        username: String,
        password: String,
        phoneNumber: String,
        firstName: String?,
        lastName: String?,
        completion: @escaping (Result<Token, UIError>) -> Void
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
                    completion(.success(Token(dto: dto.data)))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func login(
        userName: String,
        password: String,
        completion: @escaping (Result<Token, UIError>) -> Void
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
                    completion(.success(Token(dto: dto.data)))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    public func getUserData(username: String, token: String, completion: @escaping (Result<User, UIError>) -> Void) {
        let parameters = [
            "username": username
        ]
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .contentType("application/json")
        ]

        requestManager.request(
            baseURL: endpointConfig.getUserDataEndpoint,
            headers: headers,
            parameters: parameters,
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
    
//    public func addContact(username: String, token: String, completion: @escaping (Result<String, Error>) -> Void) {
//        let parameters = [
//            "username": username
//        ]
//
//        let header = [
//            "token": token
//        ]
//
//        requestManager.register(
//            baseURL: endpointConfig.addContactEndpoint,
//            header: header,
//            parameters: parameters,
//            method: .post,
//            completion: completion
//        )
//    }
}
