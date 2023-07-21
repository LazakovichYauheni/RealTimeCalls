//
//  FloatingTextFieldMask.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 19.06.23.
//

import Foundation

public struct FloatingTextFieldMask {
    var mask: String?
    var isCharactersOnlyUppercased: Bool
    var validCharacters: [Character: Character]?

    public init(
        mask: String? = nil,
        isCharactersOnlyUppercased: Bool,
        validCharacters: [Character: Character]? = nil
    ) {
        self.mask = mask
        self.isCharactersOnlyUppercased = isCharactersOnlyUppercased
        self.validCharacters = validCharacters
    }
}
