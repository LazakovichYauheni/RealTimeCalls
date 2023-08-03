//
//  LoginView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol RegisterViewEventsRespondable {
    func registerTapped()
    func googleTapped()
}

public final class RegisterView: UIView {
    private lazy var scrollView: CustomScrollView = {
        let scroll = CustomScrollView()
        scroll.decelerationRate = .fast
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var containerView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium24
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium16
        label.textColor = UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24)
        label.numberOfLines = .zero
        return label
    }()

    private lazy var fieldsView = RegisterFieldsView()
    
    private lazy var registerButton: PrimaryButton<DefaultButtonStyle> = {
        let button = PrimaryButton<DefaultButtonStyle>()
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleButton: PrimaryButton<SecondaryButtonStyle> = {
        let button = PrimaryButton<SecondaryButtonStyle>()
        button.setTitle("Sign Up with Google", for: .normal)
        button.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedFieldID: Int = .zero
    private lazy var responder = Weak(firstResponder(of: RegisterViewEventsRespondable.self))
    
    private func initialize() {
        backgroundColor = UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        gestureRecognizer.delegate = self
        addGestureRecognizer(gestureRecognizer)
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
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(fieldsView)
        containerView.addSubview(registerButton)
        containerView.addSubview(googleButton)
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space32)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(spacer.space32)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        fieldsView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacer.space42)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(fieldsView.snp.bottom).offset(70)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(60)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(60)
        }
    }
    
    @objc private func viewDidTapped(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc private func registerTapped() {
        registerButton.startAnimating()
        responder.object?.registerTapped()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardHeight + fieldsView.subviews[0].subviews[selectedFieldID].frame.height
            scrollView.contentInset = contentInset
            scrollView.scrollRectToVisible(fieldsView.subviews[0].subviews[selectedFieldID].frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
    
    @objc private func googleTapped() {
        responder.object?.googleTapped()
    }
}

extension RegisterView {
    struct ViewModel {
        let title: String
        let description: String
        let registerButtonTitle: String
        let fieldsViewModel: FieldsView.ViewModel
        let isRegisterButtonEnabled: Bool
        let didEndEditing: Bool
        let selectedFieldID: Int
    }
    func configure(viewModel: RegisterView.ViewModel) {
        if viewModel.didEndEditing {
            endEditing(true)
        }
        selectedFieldID = viewModel.selectedFieldID
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        fieldsView.configure(viewModel: viewModel.fieldsViewModel)
        registerButton.stopAnimating()
        registerButton.isEnabled = viewModel.isRegisterButtonEnabled
        registerButton.setTitle(viewModel.registerButtonTitle, for: .normal)
    }
}

extension RegisterView: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
