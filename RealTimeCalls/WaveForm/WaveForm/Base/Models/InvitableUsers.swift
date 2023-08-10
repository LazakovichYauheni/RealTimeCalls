//
//  InvitableUsers.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 8.08.23.
//

import Foundation

public struct InvitableUsers {
    let searchedUsers: [User]
    
    init(dto: InvitableUsersDTO) {
        searchedUsers = dto.searchedUsers.compactMap { User(dto: $0) }
    }
}
