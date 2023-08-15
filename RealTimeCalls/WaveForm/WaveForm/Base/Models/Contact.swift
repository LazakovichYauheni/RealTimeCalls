//
//  Contact.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct Contact {
    public let id: String
    public let firstName: String?
    public let lastName: String?
    public let username: String
    public let imageString: String?
    public let isFavorite: Bool

    // MARK: Lifecycle
    
    public init(dto: ContactDTO) {
        self.id = dto.id
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.username = dto.username
        self.imageString = dto.imageString
        self.isFavorite = dto.isFavorite
    }
}
