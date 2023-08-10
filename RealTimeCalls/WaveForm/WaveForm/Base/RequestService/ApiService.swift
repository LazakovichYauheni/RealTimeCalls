//
//  ApiService.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

/// Сервисы API
@frozen public enum ApiService {
    /// Сервис расчетных листов
    case login
    case loginByGoogle
    case registration
    case registerByGoogle
    case users
    case addContact
    case getUserData
    case checkUser

    // MARK: - Private Properties

    private var baseEndpoint: String {
        "https://super-mybg.onrender.com"
    }

    // MARK: - Public Properties

    public func endpoint() -> String {
        let auth = "/auth"
        switch self {
        case .login:
            return "\(baseEndpoint)\(auth)/login"
        case .loginByGoogle:
            return "\(baseEndpoint)\(auth)/loginByGoogle"
        case .registration:
            return "\(baseEndpoint)\(auth)/registration"
        case .registerByGoogle:
            return "\(baseEndpoint)\(auth)/registrationByGoogle"
        case .users:
            return "\(baseEndpoint)\(auth)/users"
        case .addContact:
            return "\(baseEndpoint)\(auth)/addContact"
        case .getUserData:
            return "\(baseEndpoint)\(auth)/getUserData"
        case .checkUser:
            return "\(baseEndpoint)\(auth)/checkUsers"
        }
    }
}
