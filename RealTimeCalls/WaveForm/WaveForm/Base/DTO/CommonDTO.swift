//
//  ApiResponseDTO.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 22.06.23.
//

import Foundation

public struct ApiResponseDTO<DataType: Decodable>: Decodable {
    public let data: DataType
}

public struct SuccessResponseDTO: Decodable {
    public let success: Bool
}
