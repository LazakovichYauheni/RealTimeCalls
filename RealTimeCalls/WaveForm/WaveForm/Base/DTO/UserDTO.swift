//
//  UserDTO.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct UserDataDTO: Decodable {
    public let user: UserDTO
}

public struct UserDTO {
    public let id: String
    public let username: String
    public let password: String?
    public let firstName: String?
    public let lastName: String?
    public let phoneNumber: String?
    public let contacts: [ContactDTO]
    public let recentContacts: [RecentContactDTO]
    public let favoritesContacts: [ContactDTO]?
}

extension UserDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case password
        case firstName
        case lastName
        case contacts
        case phoneNumber
        case recentContacts
        case favoritesContacts
    }
}
