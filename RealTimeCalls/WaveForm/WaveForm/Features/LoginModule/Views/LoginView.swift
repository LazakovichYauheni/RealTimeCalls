//
//  LoginView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol LoginViewEventsRespondable {
    func loginTapped()
    func googleTapped()
    func signUpTapped()
}

public final class LoginView: UIView {
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
    
    private lazy var filterView = FilterView(frame: .zero)
    
    private lazy var fieldsView = FieldsView()
    
    private lazy var loginButton: PrimaryButton<DefaultButtonStyle> = {
        let button = PrimaryButton<DefaultButtonStyle>()
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium15
        label.textColor = UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24)
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.text = "or"
        return label
    }()
    
    private lazy var googleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium15
        label.textColor = UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24)
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.text = "Sign in with Google or Facebook"
        return label
    }()
    
    private lazy var googleButton: PrimaryButton<SecondaryButtonStyle> = {
        let button = PrimaryButton<SecondaryButtonStyle>()
        button.setTitle("Google", for: .normal)
        button.addTarget(self, action: #selector(googleTapped), for: .touchUpInside)
        return button
    }()

    private lazy var container = UIView()
    
    private lazy var dontHaveAccLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium15
        label.textColor = UIColor(red: 12 / 255, green: 38 / 255, blue: 61 / 255, alpha: 0.24)
        label.textAlignment = .center
        label.text = "Don't have an account?"
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = Fonts.Medium.medium15
        button.setTitleColor(UIColor(red: 44 / 255, green: 102 / 255, blue: 189 / 255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var responder = Weak(firstResponder(of: LoginViewEventsRespondable.self))
    
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
        containerView.addSubview(filterView)
        containerView.addSubview(fieldsView)
        containerView.addSubview(loginButton)
        containerView.addSubview(orLabel)
        containerView.addSubview(googleLabel)
        containerView.addSubview(googleButton)
        containerView.addSubview(container)
        container.addSubview(dontHaveAccLabel)
        container.addSubview(signUpButton)
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
        
        filterView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(spacer.space56)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(spacer.space56)
        }
        
        fieldsView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(spacer.space42)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(fieldsView.snp.bottom).offset(spacer.space56)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(spacer.space60)
        }
        
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(spacer.space16)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        googleLabel.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(spacer.space16)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(googleLabel.snp.bottom).offset(spacer.space30)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(spacer.space60)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(spacer.space16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(spacer.space60)
        }
        
        dontHaveAccLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(dontHaveAccLabel.snp.trailing).offset(spacer.space2)
        }
    }
    
    @objc private func viewDidTapped(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc private func loginTapped() {
        loginButton.startAnimating()
        responder.object?.loginTapped()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardHeight
            scrollView.contentInset = contentInset
            scrollView.scrollRectToVisible(loginButton.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
    }
    
    @objc private func googleTapped() {
        responder.object?.googleTapped()
    }
    
    @objc private func signUpTapped() {
        responder.object?.signUpTapped()
    }
}

extension LoginView {
    struct ViewModel {
        let title: String
        let description: String
        let loginButtonTitle: String
        let filterViewModel: FilterView.ViewModel
        let fieldsViewModel: FieldsView.ViewModel
        let isLoginButtonEnabled: Bool
        let didEndEditing: Bool
    }
    func configure(viewModel: LoginView.ViewModel) {
        if viewModel.didEndEditing {
            endEditing(true)
        }
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        filterView.configure(viewModel: viewModel.filterViewModel)
        fieldsView.configure(viewModel: viewModel.fieldsViewModel)
        loginButton.stopAnimating()
        loginButton.isEnabled = viewModel.isLoginButtonEnabled
        loginButton.setTitle(viewModel.loginButtonTitle, for: .normal)
    }
}

extension LoginView: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        let checkingFrame = fieldsView.convert(fieldsView.frame, to: self)
        return !checkingFrame.contains(location)
    }
}
