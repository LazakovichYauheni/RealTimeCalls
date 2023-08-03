//
//  Contact.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct Contact {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let phoneNumber: String
    public let isFavorite: Bool

    // MARK: Lifecycle
    
    public init(dto: ContactDTO) {
        self.id = dto.id
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.phoneNumber = dto.phoneNumber
        self.isFavorite = dto.isFavorite
    }
}
