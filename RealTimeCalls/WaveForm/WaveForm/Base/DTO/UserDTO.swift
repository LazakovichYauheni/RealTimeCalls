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
    public let password: String
    public let firstName: String?
    public let lastName: String?
    public let phoneNumber: String
    public let contacts: [ContactDTO]
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
    }

//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let id = try container.decode(String.self, forKey: CodingKeys.id)
//        let username = try container.decode(String.self, forKey: CodingKeys.username)
//        let password = try container.decode(String.self, forKey: CodingKeys.password)
//        let firstName = try? container.decode(String.self, forKey: CodingKeys.firstName)
//        let lastName = try? container.decode(String.self, forKey: CodingKeys.lastName)
//        let contacts = try container.decode([ContactDTO].self, forKey: CodingKeys.contacts)
//
//        self.init(
//            id: id,
//            username: username,
//            password: password,
//            firstName: firstName,
//            lastName: lastName,
//            contacts: contacts
//        )
//    }

    //public func encode(to _: Encoder) throws {}
}
