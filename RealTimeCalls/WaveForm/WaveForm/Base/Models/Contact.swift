//
//  Contact.swift
//  WaveForm
//
//  Created by Doctor Kocte on 13.06.23.
//

import Foundation

public struct Contact {
    public let id: String?
    public let username: String?

    // MARK: Lifecycle

//    public init(id: String?, username: String?) {
//        self.id = id
//        self.username = username
//    }
    
    public init(dto: ContactDTO) {
        self.id = dto.id
        self.username = dto.username
    }
}

//extension Contact: Codable {
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case username
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let id = try? container.decode(String.self, forKey: CodingKeys.id)
//        let username = try? container.decode(String.self, forKey: CodingKeys.username)
//
//        self.init(id: id, username: username)
//    }
//}
