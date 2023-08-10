// FloatingTextFieldView.swift

import UIKit

/// Описывает основные методы, которые должны обрабатываться Responder для этой View
public protocol FloatingTextFieldViewEventsRespondable {
    /// Обработка нажатия на view иконки
    func tapRightIconButton(id: String)
    func tapSuccessIconButton(id: String)
    func shouldReturnAction(text: String)
}

public extension FloatingTextFieldViewEventsRespondable {
    func shouldReturnAction(text: String) {}
}

public final class FloatingTextFieldView: UIView, UITextFieldDelegate {
    // MARK: - Subview Properties

    private let textField: FloatingTextField = {
        let textField = FloatingTextField()
        textField.autocorrectionType = .no
        textField.textColor = .black
        return textField
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.closeImage
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = spacer.space8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var findStatusContainerView = UIView()
    
    private lazy var successIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.successImage
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(successTapped)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var loaderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.loaderImage.withTintColor(.blue)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    // MARK: - Private Properties

    private var formatter: FloatingTextFieldTextFormatter? {
        didSet(oldFormatter) {
            guard
                formatter != nil,
                oldFormatter != nil
            else { return }
            let text = textField.text ?? .empty

            let selectedRange = textField.selectedCharactersRange ?? text.startIndex ..< text.startIndex

            var unformattedText = text
            var unformattedRange = selectedRange

            if let oldFormatter = oldFormatter {
                (unformattedText, unformattedRange) = oldFormatter.unformattedText(from: text, range: selectedRange)
            }

            var formattedText = unformattedText

            if let formatter = formatter {
                (formattedText, _) = formatter.formattedText(
                    from: unformattedText,
                    range: unformattedRange
                )
            }

            textField.text = formattedText
        }
    }

    private var processor: FloatingTextFieldTextProcessor?
    private lazy var responder = Weak(firstResponder(of: FloatingTextFieldViewEventsRespondable.self))
    private var textFieldMask: FloatingTextFieldMask?

    // MARK: - UIView

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
        textField.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(textField)
        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(findStatusContainerView)
        findStatusContainerView.addSubview(successIconImageView)
        findStatusContainerView.addSubview(loaderImageView)
    }

    private func makeConstraints() {
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(spacer.space8)
        }

        textField.snp.makeConstraints { make in
            make.height.equalTo(spacer.space56)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
        
        findStatusContainerView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
        
        successIconImageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }

        loaderImageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
    }

    // MARK: - UITextFieldDelegate

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textFieldMask != nil {
            guard let processor = processor else { return true }
            return string != .space
                ? processor.shouldChangeCharacters(in: range, replacementString: string, textField: textField)
                : false
        } else {
            return true
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc private func imageTapped() {
        responder.object?.tapRightIconButton(id: textField.id ?? "")
    }
    
    @objc private func successTapped() {
        responder.object?.tapSuccessIconButton(id: textField.id ?? "")
    }
}

// MARK: - ViewConfigurable

extension FloatingTextFieldView {
    public struct ViewModel {
        let textField: FloatingTextField.ViewModel
        let isBecomeFirstResponder: Bool
        let mask: FloatingTextFieldMask?
        let isInvalidInput: Bool
        let isNeedToShowClearButton: Bool
        let isNeedToShowSuccessButton: Bool
        let isNeedToShowLoader: Bool

        public init(
            textField: FloatingTextField.ViewModel,
            isBecomeFirstResponder: Bool = false,
            mask: FloatingTextFieldMask? = nil,
            isInvalidInput: Bool,
            isNeedToShowClearButton: Bool,
            isNeedToShowSuccessButton: Bool = false,
            isNeedToShowLoader: Bool = false
        ) {
            self.isBecomeFirstResponder = isBecomeFirstResponder
            self.textField = textField
            self.mask = mask
            self.isInvalidInput = isInvalidInput
            self.isNeedToShowClearButton = isNeedToShowClearButton
            self.isNeedToShowSuccessButton = isNeedToShowSuccessButton
            self.isNeedToShowLoader = isNeedToShowLoader
        }
    }

    public func configure(with viewModel: ViewModel) {
        textField.keyboardType = .default
        textField.spellCheckingType = .no
        textField.configure(with: viewModel.textField)
        if
            let mask = viewModel.mask,
            let inputMask = mask.mask {
            formatter = FloatingTextFieldTextFormatter(
                mask: inputMask,
                validCharacters: mask.validCharacters,
                isCharactersOnlyUppercased: mask.isCharactersOnlyUppercased
            )
            
            processor = FloatingTextFieldTextProcessor(
                validCharacters: mask.validCharacters,
                isCharactersOnlyUppercased: mask.isCharactersOnlyUppercased,
                formatter: formatter
            )
            textField.delegate = self
            textFieldMask = viewModel.mask
        } else {
            formatter = nil
            processor = nil
            textFieldMask = nil
            textField.delegate = nil
        }
        
        findStatusContainerView.isHidden = !viewModel.isNeedToShowSuccessButton && !viewModel.isNeedToShowLoader
                
        UIView.animate(withDuration: 0.15) {
            self.successIconImageView.isHidden = !viewModel.isNeedToShowSuccessButton
            self.successIconImageView.alpha = viewModel.isNeedToShowSuccessButton ? 1 : .zero
            self.loaderImageView.isHidden = !viewModel.isNeedToShowLoader
            self.loaderImageView.alpha = viewModel.isNeedToShowLoader ? 1 : .zero
        }
        
        if viewModel.isNeedToShowLoader {
            loaderImageView.rotate()
        } else {
            loaderImageView.stopRotating()
        }
        
        iconImageView.isHidden = !viewModel.isNeedToShowClearButton
        
        
        if viewModel.isBecomeFirstResponder, textField.canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }
}

