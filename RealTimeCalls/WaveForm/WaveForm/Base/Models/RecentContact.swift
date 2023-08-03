//
//  RecentContact.swift
//  WaveForm
//
//  Created by Doctor Kocte on 21.07.23.
//

import Foundation

public struct RecentContact {
    public let date: Date?
    public let contact: Contact
    
    public init(dto: RecentContactDTO) {
        self.date = dto.date
        self.contact = Contact(dto: dto.contact)
    }
}
