// FloatingTextField.swift

import UIKit

// MARK: - Constants

private enum Constants {
    /// Коэффициент увеличения текста
    static let scale: CGFloat = 1.154
    ///  Коэффициент увеличения  шрифта
    static let titleFontScale: CGFloat = 0.7
    /// Длительность анимации перехода для плейсхолдера
    static let animationDuration = 0.1
    /// X координата плейсхолдера
    static let titleRectXCoordinate: CGFloat = 16
    /// Y координата плейсхолдера
    static let titleRectYCoordinate: CGFloat = 6
    /// Сдвиг текстового блока по горизонтали
    static let xOffset: CGFloat = 16
    /// Сдвиг текстового блока по вертикали
    static let yOffset: CGFloat = 10
    /// Константа для увеличения высоты шрифта
    static let additionalFontHeight: CGFloat = 9
}

private struct StringStyle {
    let font: UIFont?
}

/// Класс конфигурации плейсхолдера
private struct TitleConfig {
    /// Стиль плейсхолдера
    let style: StringStyle
    /// Преобразование размера текста
    let scaleTransform: CGAffineTransform
}

public protocol FloatingTextFieldEventsRespondable {
    /// Обрабатывает начало редактирования
    func textFieldDidBeginEditing(text: String, id: String)
    /// Обрабатывает конец редактирования
    func textFieldDidEndEditing(text: String, id: String)
    /// Обрабатывает изменение введенной строки
    func textFieldDidChange(text: String, id: String)
}

public final class FloatingTextField: UITextField {
    // MARK: - Types

    /// Состояния плейсхолдера
    private enum FieldState {
        /// Неактивное
        case collapsed
        /// Активное
        case expanded
    }

    // MARK: - Subview Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
        return label
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
        label.font = Fonts.Regular.regular15
        return label
    }()

    // MARK: - Private Properties

    private let titleStyles: [FieldState: TitleConfig] = [
        .collapsed: TitleConfig(
            style: StringStyle(font: Fonts.Regular.regular13),
            scaleTransform: CGAffineTransform(scaleX: Constants.scale, y: Constants.scale)
        ),
        .expanded: TitleConfig(
            style: StringStyle(font: Fonts.Regular.regular13),
            scaleTransform: .identity
        )
    ]

    private lazy var responder = Weak(firstResponder(of: FloatingTextFieldEventsRespondable.self))
    private var id: String?
    private var titleText: String?
    private var caretPosition: UITextPosition?

    private var titleHeight: CGFloat {
        makeTitleFontFromFont(titleLabel.font).lineHeight + Constants.additionalFontHeight
    }

    private var placeholderAlpha: CGFloat {
        let isEmpty: Bool
        if let text = text {
            isEmpty = text.isEmpty
        } else {
            isEmpty = true
        }

        return (isFirstResponder && isEmpty) ? 1.0 : 0.0
    }

    // MARK: - UITextField

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
        commonInit()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        guard !isFirstResponder else { return }
        drawViewsForRect(rect)
    }

    override public var text: String? {
        didSet {
            guard
                let text = text,
                !text.isEmpty
            else { return }
            updateStyle(fieldStyle: titleStyles[.expanded])
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.offsetBy(dx: Constants.xOffset, dy: Constants.yOffset)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let text = text else { return .zero }
        if isFirstResponder || !text.isEmpty {
            return CGRect(
                x: Constants.titleRectXCoordinate,
                y: Constants.titleRectYCoordinate,
                width: UIScreen.main.bounds.width,
                height: titleHeight
            )
        } else {
            return bounds.offsetBy(dx: Constants.xOffset, dy: .zero)
        }
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    override public func caretRect(for position: UITextPosition) -> CGRect {
        caretPosition = position
        var rect = super.caretRect(for: position)
        rect.size.width = 1
        return rect
    }

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidEndEditing(notification:)),
            name: UITextField.textDidEndEditingNotification,
            object: self
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidBeginEditing(notification:)),
            name: UITextField.textDidBeginEditingNotification,
            object: self
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChanged(notification:)),
            name: UITextField.textDidChangeNotification,
            object: self
        )
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(placeholderLabel)
    }

    private func drawViewsForRect(_ rect: CGRect) {
        let titleStyle = (text?.isEmpty ?? true) ? titleStyles[.collapsed] : titleStyles[.expanded]
        updateStyle(fieldStyle: titleStyle)
        if text?.isEmpty ?? true {
            titleLabel.frame = bounds.offsetBy(dx: Constants.xOffset, dy: .zero)
        }
    }

    private func animateTitle(fieldState: FieldState, titleStyle: TitleConfig?) {
        if
            fieldState == .expanded,
            let text = text,
            !text.isEmpty {
            updateStyle(fieldStyle: titleStyles[.expanded])
        } else {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.updateStyle(fieldStyle: titleStyle)
            }
        }
    }

    private func makeTitleFontFromFont(_ font: UIFont) -> UIFont {
        let font = UIFont(descriptor: font.fontDescriptor, size: font.pointSize * Constants.titleFontScale)
        return font
    }

    private func updateStyle(fieldStyle: TitleConfig?) {
        guard
            let fieldStyle = fieldStyle,
            let titleText = titleText
        else { return }

        titleLabel.transform = fieldStyle.scaleTransform
        titleLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.frame = textRect(forBounds: bounds)
        placeholderLabel.alpha = placeholderAlpha

        titleLabel.font = fieldStyle.style.font
        titleLabel.text = titleText
    }

    private func setCaretPosition() {
        guard let caretPosition = caretPosition else { return }
        selectedTextRange = textRange(from: caretPosition, to: caretPosition)
    }

    @objc private func textFieldDidBeginEditing(notification: NSNotification) {
        animateTitle(fieldState: .expanded, titleStyle: titleStyles[.expanded])
        guard
            let textField = notification.object as? UITextField,
            let text = textField.text,
            let id = id
        else { return }
        responder.object?.textFieldDidBeginEditing(text: text, id: id)
    }

    @objc private func textFieldDidEndEditing(notification: NSNotification) {
        animateTitle(fieldState: .expanded, titleStyle: titleStyles[.collapsed])
        guard
            let textField = notification.object as? UITextField,
            let text = textField.text,
            let id = id
        else { return }
        responder.object?.textFieldDidEndEditing(text: text, id: id)
    }

    @objc private func textFieldDidChanged(notification: NSNotification) {
        guard
            let textField = notification.object as? UITextField,
            let text = textField.text,
            let id = id
        else { return }
        responder.object?.textFieldDidChange(text: text, id: id)
        placeholderLabel.alpha = placeholderAlpha
    }
}

// MARK: - ViewConfigurable

extension FloatingTextField {
    public struct ViewModel {
        let title: String?
        let id: String
        var text: String?
        let placeholder: String?

        public init(
            title: String?,
            id: String,
            text: String? = nil,
            placeholder: String? = nil
        ) {
            self.title = title
            self.id = id
            self.text = text
            self.placeholder = placeholder
        }
    }

    public func configure(with viewModel: ViewModel) {
        titleText = viewModel.title
        id = viewModel.id
        if text != viewModel.text {
            text = viewModel.text
        }

        placeholderLabel.text = viewModel.placeholder
        guard !isFirstResponder else { return }
        drawViewsForRect(self.frame)
    }
}

