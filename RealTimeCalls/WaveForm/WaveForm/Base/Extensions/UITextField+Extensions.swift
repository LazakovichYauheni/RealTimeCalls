//
//  UITextField+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

extension UITextField {
    /// Возвращает корректный Range, где был поставлен курсор
    var selectedCharactersRange: Range<String.Index>? {
        guard
            let selectedTextRange = selectedTextRange,
            let text = text
        else { return nil }

        let location = offset(from: beginningOfDocument, to: selectedTextRange.start)
        let length = offset(from: selectedTextRange.start, to: selectedTextRange.end)
        let range = text.range(from: NSMakeRange(location, length))

        return range
    }
}
