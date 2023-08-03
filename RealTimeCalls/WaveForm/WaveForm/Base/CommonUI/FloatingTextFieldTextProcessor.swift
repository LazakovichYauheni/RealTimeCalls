// FloatingTextFieldTextProcessor.swift

// MARK: - Constants

import UIKit

/// Процессор, который занимается преобразованием Range и NSRange
public final class FloatingTextFieldTextProcessor {
    // MARK: - Private Properties

    private let validCharacters: [Character: Character]?
    private let isCharactersOnlyUppercased: Bool?
    private let formatter: FloatingTextFieldTextFormatter?

    // MARK: - Init

    public init(
        validCharacters: [Character: Character]?,
        isCharactersOnlyUppercased: Bool?,
        formatter: FloatingTextFieldTextFormatter?
    ) {
        self.validCharacters = validCharacters
        self.isCharactersOnlyUppercased = isCharactersOnlyUppercased
        self.formatter = formatter
    }

    // MARK: - Public Properties

    /// Метод, который возвращает true, если элемент в введенной строке необходимо заменить и false, если нет
    /// - Parameters:
    ///     - range: Range от начала строки до введенного символа
    ///     - string: Введенный символ
    ///     - textFIeld: TextField, в котором был введен символ
    public func shouldChangeCharacters(
        in range: NSRange,
        replacementString string: String,
        textField: UITextField
    ) -> Bool {
        let text = textField.text ?? .empty

        guard
            let charactersRange = text.range(from: range),
            checkValidString(string: string)
        else { return false }

        var (unformattedText, unformattedRange) = makeUnformattedTextAndRange(text: text, range: charactersRange)

        let isBackspace = (string.isEmpty && unformattedRange.isEmpty)

        if
            isBackspace,
            unformattedRange.lowerBound != unformattedText.startIndex {
            let lowerBound = unformattedText.index(before: unformattedRange.lowerBound)
            unformattedRange = lowerBound ..< unformattedRange.upperBound
        }

        let (newUnformattedText, cursorPosition) = makeCursorPositionAndNewUnformattedText(
            unformattedString: unformattedText,
            string: string,
            range: unformattedRange
        )

        var (formattedText, formattedRange) = makeFormattedTextAndRange(
            newUnformattedText: newUnformattedText,
            cursorPosition: cursorPosition
        )

        if
            let isCharactersOnlyUppercased = isCharactersOnlyUppercased,
            isCharactersOnlyUppercased {
            formattedText = formattedText.uppercased()
        }

        textField.text = formattedText

        guard
            let range = makeFormattedNSRange(range: formattedRange, text: formattedText),
            let from = textField.position(from: textField.beginningOfDocument, offset: range.location),
            let to = textField.position(from: from, offset: range.length)
        else { return false }

        textField.selectedTextRange = textField.textRange(from: from, to: to)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
        return false
    }

    // MARK: - Private Methods

    private func makeFormattedNSRange(range: Range<String.Index>, text: String) -> NSRange? {
        let bound = String.Index(
            utf16Offset: range.upperBound.utf16Offset(in: text),
            in: text
        )

        let nsRange = text.nsRange(from: bound ..< bound)
        return nsRange
    }

    private func checkValidString(string: String) -> Bool {
        guard let validCharacters = validCharacters else { return true }

        var newString = string
        var isValid = true

        if
            let isCharactersOnlyUppercased = isCharactersOnlyUppercased,
            isCharactersOnlyUppercased {
            newString = newString.uppercased()
        }

        let charactersArray = Array(newString)

        charactersArray.forEach { character in
            guard validCharacters[character] != nil else {
                isValid = false
                return
            }
        }
        return isValid
    }

    private func makeUnformattedTextAndRange(
        text: String,
        range: Range<String.Index>
    ) -> (String, Range<String.Index>) {
        if let formatter = formatter {
            return formatter.unformattedText(from: text, range: range)
        } else {
            return (text, range)
        }
    }

    private func makeCursorPositionAndNewUnformattedText(
        unformattedString: String,
        string: String,
        range: Range<String.Index>
    ) -> (String, String.Index) {
        let newUnformattedText = unformattedString.replacingCharacters(
            in: range,
            with: string
        )
        let selectionOffset = unformattedString.distance(
            from: unformattedString.startIndex,
            to: range.lowerBound
        )

        let (newText, cursorPosition) = (
            newUnformattedText,
            newUnformattedText.index(
                newUnformattedText.startIndex,
                offsetBy: selectionOffset + string.count
            )
        )

        return (newText, cursorPosition)
    }

    private func makeFormattedTextAndRange(
        newUnformattedText: String,
        cursorPosition: String.Index
    ) -> (String, Range<String.Index>) {
        if let formatter = formatter {
            return formatter.formattedText(
                from: newUnformattedText,
                range: cursorPosition ..< cursorPosition
            )
        } else {
            return (newUnformattedText, cursorPosition ..< cursorPosition)
        }
    }
}
