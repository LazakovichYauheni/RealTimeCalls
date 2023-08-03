//
//  RecentContactDTO.swift
//  WaveForm
//
//  Created by Doctor Kocte on 21.07.23.
//

import Foundation

public struct RecentContactDTO: Codable {
    public let date: Date?
    public let contact: ContactDTO
}
