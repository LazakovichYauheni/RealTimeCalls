import UIKit
import SnapKit

private extension Spacer {
    var space52: CGFloat { 52 }
}

protocol UserDetailsContentViewEventsRespondable: AnyObject {
    func didCloseButtonTapped()
    func didOKButtonTapped(
        titleText: String,
        descriptionText: String,
        noticeText: String
    )
}

/// View для заполнения иконок с фоном
public final class UserDetailsContentView: UIView {
    // MARK: - Subview Properties
    
    private lazy var textContainerView = UIView()
    
    private lazy var titleContainerView = UIView()
    private lazy var descriptionContainerView = UIView()
    private lazy var noticeContainerView = UIView()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium36
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular28
        label.textColor = Color.current.text.whiteColor
        return label
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular20
        label.numberOfLines = .zero
        label.textColor = Color.current.text.noticeColor
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        textField.textColor = Color.current.text.whiteColor
        textField.font = Fonts.Medium.medium36
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        textField.textColor = Color.current.text.whiteColor
        textField.font = Fonts.Regular.regular28
        return textField
    }()
    
    private lazy var noticeTextField: UITextField = {
        let textField = UITextField()
        textField.isHidden = true
        textField.textColor = Color.current.text.whiteColor
        textField.font = Fonts.Regular.regular20
        return textField
    }()
    
    private lazy var closeButton: PrimaryButton<DefaultRadius30ButtonStyle> = {
        let button = PrimaryButton<DefaultRadius30ButtonStyle>()
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private Properties
    
    private var isEditMode = false
    private lazy var responder = Weak(firstResponder(of: UserDetailsContentViewEventsRespondable.self))

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func commonInit() {
        layer.cornerRadius = spacer.space18
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubviews()
        makeConstraints()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        gestureRecognizer.delegate = self
        addGestureRecognizer(gestureRecognizer)
    }

    private func addSubviews() {
        addSubview(textContainerView)
        textContainerView.addSubview(titleContainerView)
        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(titleTextField)
        textContainerView.addSubview(descriptionContainerView)
        descriptionContainerView.addSubview(descriptionLabel)
        descriptionContainerView.addSubview(descriptionTextField)
        textContainerView.addSubview(noticeContainerView)
        noticeContainerView.addSubview(noticeLabel)
        noticeContainerView.addSubview(noticeTextField)
        addSubview(closeButton)
    }

    private func makeConstraints() {
        textContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space30)
            make.leading.equalToSuperview().inset(spacer.space16)
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(spacer.space16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space4)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview().inset(spacer.space16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeContainerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacer.space36)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noticeTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(textContainerView.snp.bottom)
            make.bottom.equalToSuperview().inset(spacer.space52)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
    }
    
    @objc private func closeButtonTapped() {
        if isEditMode {
            closeButton.startAnimating()
            responder.object?.didOKButtonTapped(
                titleText: titleTextField.text ?? .empty,
                descriptionText: descriptionTextField.text ?? .empty,
                noticeText: noticeTextField.text ?? .empty
            )
        } else {
            titleLabel.isHidden = true
            descriptionLabel.isHidden = true
            responder.object?.didCloseButtonTapped()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            let keyboardHeight = keyboardSize.height
//            frame.origin.y = -keyboardHeight
//        }
    }
    
    @objc private func keyboardWillHide() {
        //frame.origin.y = .zero
    }
    
    @objc private func viewDidTapped(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
}

// MARK: - Configurable

extension UserDetailsContentView {
    public struct ViewModel {
        let background: UIColor
        let buttonBackground: UIColor
        let title: String
        let description: String
        let notice: String?
        let isEditMode: Bool
        let isButtonAnimationNeeded: Bool
    }

    public func configure(with viewModel: ViewModel) {
        isEditMode = viewModel.isEditMode
        backgroundColor = viewModel.background
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        noticeLabel.text = viewModel.notice
        if viewModel.isEditMode {
            closeButton.setTitle("OK", for: .normal)
            titleLabel.isHidden = true
            titleTextField.isHidden = false
            titleTextField.text = titleLabel.text
            
            descriptionLabel.isHidden = true
            descriptionTextField.isHidden = false
            descriptionTextField.text = descriptionLabel.text
            
            noticeLabel.isHidden = true
            noticeTextField.isHidden = false
            noticeTextField.text = noticeLabel.text

        } else {
            if viewModel.isButtonAnimationNeeded {
                closeButton.startAnimating()
            } else {
                closeButton.stopAnimating()
                closeButton.setTitle("Close", for: .normal)
            }
            titleLabel.isHidden = false
            titleTextField.isHidden = true
            descriptionLabel.isHidden = false
            descriptionTextField.isHidden = true
            noticeLabel.isHidden = false
            noticeTextField.isHidden = true
        }
        closeButton.setBackgroundColor(color: viewModel.buttonBackground)
    }
}

extension UserDetailsContentView: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        let checkingFrame = textContainerView.convert(textContainerView.frame, to: self)
        return !checkingFrame.contains(location)
    }
}

