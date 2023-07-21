//
//  Token.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 22.06.23.
//

import Foundation

public struct Token {
    public let token: String
    
    public init(dto: TokenDTO) {
        token = dto.token
    }
}
