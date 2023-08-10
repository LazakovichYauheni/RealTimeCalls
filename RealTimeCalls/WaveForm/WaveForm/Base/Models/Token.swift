//
//  Token.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 22.06.23.
//

import Foundation

public struct Token {
    public let accessToken: String
    public let refreshToken: String
    
    public init(dto: TokenDTO) {
        accessToken = dto.accessToken
        refreshToken = dto.refreshToken
    }
}
