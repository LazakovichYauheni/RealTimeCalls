//
//  String+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation

extension String {
    public static let space = " "
    public static let empty = ""
    
    /// Получить Range из NSRange
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let lowerBound = index(startIndex, offsetBy: nsRange.location, limitedBy: endIndex),
            let upperBound = index(lowerBound, offsetBy: nsRange.length, limitedBy: endIndex)
        else { return nil }

        return lowerBound ..< upperBound
    }

    /// Получить NSRange из Range
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let lowerBound = String.Index(utf16Offset: range.lowerBound.utf16Offset(in: self), in: self)
        let upperBound = String.Index(utf16Offset: range.upperBound.utf16Offset(in: self), in: self)

        let location = utf16.distance(from: utf16.startIndex, to: lowerBound)
        let length = utf16.distance(from: lowerBound, to: upperBound)

        return NSMakeRange(location, length)
    }
}
