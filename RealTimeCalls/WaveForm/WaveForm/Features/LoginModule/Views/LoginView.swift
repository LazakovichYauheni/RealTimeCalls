//
//  LoginView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol LoginViewEventsRespondable {
    func loginTapped()
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
            make.top.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().inset(0)
            make.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().inset(0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        filterView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        fieldsView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(42)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(fieldsView.snp.bottom).offset(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        orLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        googleLabel.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        googleButton.snp.makeConstraints { make in
            make.top.equalTo(googleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(googleButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
        
        dontHaveAccLabel.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(dontHaveAccLabel.snp.trailing).offset(2)
        }
    }
    
    @objc private func viewDidTapped(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    @objc private func loginTapped() {
        loginButton.startAnimating()
        responder.object?.loginTapped()
    }
}

extension LoginView {
    struct ViewModel {
        let title: String
        let description: String
        let loginButtonTitle: String
        let isNeedToReconfigureTextFields: Bool
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
        if viewModel.isNeedToReconfigureTextFields {
            filterView.configure(viewModel: viewModel.filterViewModel)
            fieldsView.configure(viewModel: viewModel.fieldsViewModel)
        }
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
