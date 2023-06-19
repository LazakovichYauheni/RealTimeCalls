// FloatingTextFieldTextFormatter.swift

import Foundation

// MARK: - Constants

private enum Constants {
    static let maskSymbol: Character = "X"
    static let incrementValue = 1
}

/// Форматтер масок для TextField-а
public class FloatingTextFieldTextFormatter {
    // MARK: - Private Properties

    private let mask: String
    private let validCharacters: [Character: Character]?
    private let isCharactersOnlyUppercased: Bool?

    // MARK: - Init

    public init(mask: String, validCharacters: [Character: Character]?, isCharactersOnlyUppercased: Bool?) {
        self.mask = mask
        self.validCharacters = validCharacters
        self.isCharactersOnlyUppercased = isCharactersOnlyUppercased
    }

    // MARK: - Public Properties

    /// Форматирует текст с необходимой маской
    public func formattedText(
        from text: String,
        range: Range<String.Index>
    ) -> (text: String, range: Range<String.Index>) {
        let unformattedRange = NSMakeRange(
            text.distance(from: text.startIndex, to: range.lowerBound),
            text.distance(from: range.lowerBound, to: range.upperBound)
        )

        guard let prefixEndIndex = mask.range(of: String(Constants.maskSymbol))?.lowerBound else {
            return (mask, mask.startIndex ..< mask.startIndex)
        }
        var formattedText = mask[mask.startIndex ..< prefixEndIndex]
        var formattedRange = NSMakeRange(formattedText.count, .zero)

        let text = formatText(text: text)

        var index: Int = .zero
        for maskCharacter in mask[prefixEndIndex ..< mask.endIndex] {
            if index < unformattedRange.location {
                formattedRange.location += Constants.incrementValue
            } else if index < NSMaxRange(unformattedRange) {
                formattedRange.length += Constants.incrementValue
            }

            if maskCharacter == Constants.maskSymbol {
                if index >= text.count {
                    break
                }
                if let textCharacter = text[safe: text.index(text.startIndex, offsetBy: index)] {
                    formattedText.append(textCharacter)
                }
                index += Constants.incrementValue
            } else {
                if index == NSMaxRange(unformattedRange) {
                    formattedRange.length += Constants.incrementValue
                }
                formattedText.append(maskCharacter)
            }
        }

        let lowerBound = formattedText.index(formattedText.startIndex, offsetBy: formattedRange.location)
        let upperBound = formattedText.index(lowerBound, offsetBy: formattedRange.length)
        let range = makeFormattedRange(lowerBound: lowerBound, upperBound: upperBound, text: formattedText)

        return (String(formattedText), range)
    }

    /// Убирает маску из текста
    public func unformattedText(
        from text: String,
        range: Range<String.Index>
    ) -> (text: String, range: Range<String.Index>) {
        let formattedRange = NSMakeRange(
            text.distance(from: text.startIndex, to: range.lowerBound),
            text.distance(from: range.lowerBound, to: range.upperBound)
        )

        var unformattedText = String()
        var unformattedRange = NSMakeRange(.zero, .zero)

        let text = formatText(text: text)

        for i in .zero ..< min(mask.count, text.count) {
            let index = mask.index(mask.startIndex, offsetBy: i)
            let maskCharacter = mask[safe: index]
            if maskCharacter != Constants.maskSymbol {
                continue
            }

            if let textCharacter = text[safe: text.index(text.startIndex, offsetBy: i)] {
                unformattedText.append(textCharacter)
            }

            if i < formattedRange.location {
                unformattedRange.location += Constants.incrementValue
            } else if i < NSMaxRange(formattedRange) {
                unformattedRange.length += Constants.incrementValue
            }
        }

        let lowerBound = unformattedText.index(unformattedText.startIndex, offsetBy: unformattedRange.location)
        let upperBound = unformattedText.index(lowerBound, offsetBy: unformattedRange.length)

        return (unformattedText, lowerBound ..< upperBound)
    }

    // MARK: - Private Methods

    private func formatText(text: String) -> String {
        guard let validCharacters = validCharacters else { return text }
        var text = text

        if
            let isCharactersOnlyUppercased = isCharactersOnlyUppercased,
            isCharactersOnlyUppercased {
            text = text.uppercased()
        }

        let charactersArray = Array(text)
        var formattedArray: [Character] = []

        charactersArray.forEach { character in
            if let validCharacter = validCharacters[character] {
                formattedArray.append(validCharacter)
            }
        }
        return String(formattedArray)
    }

    private func makeFormattedRange(
        lowerBound: Substring.Index,
        upperBound: Substring.Index,
        text: Substring
    ) -> Range<String.Index> {
        let lowerUTF16Bound = String.Index(utf16Offset: lowerBound.utf16Offset(in: text), in: text)
        let upperUTF16Bound = String.Index(utf16Offset: upperBound.utf16Offset(in: text), in: text)

        return lowerUTF16Bound ..< upperUTF16Bound
    }
}
