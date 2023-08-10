//
//  EndpointConfig.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

/// Конфигурация запроса информации о клиенте
public class EndpointConfig {
    public var loginEndpoint: String {
        "\(ApiService.login.endpoint())"
    }
    
    public var loginByGoogleEndpoint: String {
        "\(ApiService.loginByGoogle.endpoint())"
    }
    
    public var registrationEndpoint: String {
        "\(ApiService.registration.endpoint())"
    }
    
    public var registerByGoogleEndpoint: String {
        "\(ApiService.registerByGoogle.endpoint())"
    }
    
    public var usersEndpoint: String {
        "\(ApiService.users.endpoint())"
    }
    
    public var addContactEndpoint: String {
        "\(ApiService.addContact.endpoint())"
    }
    
    public var getUserDataEndpoint: String {
        "\(ApiService.getUserData.endpoint())"
    }
    
    public var checkUserEndpoint: String {
        "\(ApiService.checkUser.endpoint())"
    }
}
