//
//  ContactDTO.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct ContactDTO {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let isFavorite: Bool
}

extension ContactDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case phoneNumber
        case isFavorite
    }
}
