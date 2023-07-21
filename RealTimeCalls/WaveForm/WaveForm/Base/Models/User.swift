//
//  User.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct UserData {
    public let user: User
    
    public init(dto: UserDataDTO) {
        user = User(dto: dto.user)
    }
}

public struct User {
    public let id: String
    public let username: String
    public let password: String
    public let firstName: String?
    public let lastName: String?
    public let phoneNumber: String
    public let contacts: [Contact]

    public init(dto: UserDTO) {
        id = dto.id
        username = dto.username
        password = dto.password
        firstName = dto.firstName
        lastName = dto.lastName
        phoneNumber = dto.phoneNumber
        contacts = dto.contacts.compactMap { Contact(dto: $0) }
    }
}
