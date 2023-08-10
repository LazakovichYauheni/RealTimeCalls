//
//  TokenDTO.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 22.06.23.
//

import Foundation

public struct TokenDTO: Decodable {
    public let accessToken: String
    public let refreshToken: String
}
