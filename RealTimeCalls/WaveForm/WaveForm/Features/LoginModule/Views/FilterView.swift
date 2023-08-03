//
//  FilterView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

public protocol FilterViewEventsRespondable {
    func usernameTapped()
    func phoneTapped()
}

enum FilterSelectionState {
    case username
    case phoneNumber
}

public final class FilterView: UIView {
    private lazy var selectedContainer: UIView = {
        let container = UIView()
        container.layer.cornerRadius = spacer.space12
        container.backgroundColor = .white
        return container
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var leftTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium13
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Username"
        return label
    }()
    
    private lazy var rightTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium13
        label.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
        label.textAlignment = .center
        label.text = "Phone number"
        return label
    }()
    
    private var preSelectionStateActive = true
    private lazy var responder = Weak(firstResponder(of: FilterViewEventsRespondable.self))
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        layer.cornerRadius = spacer.space12
        backgroundColor = UIColor(red: 216 / 255, green: 226 / 255, blue: 235 / 255, alpha: 1)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didViewTapped)))
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(selectedContainer)
        addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(leftTitle)
        horizontalStack.addArrangedSubview(rightTitle)
    }
    
    private func makeConstraints() {
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(spacer.space6)
        }
        
        selectedContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(spacer.space6)
        }
    }
    
    @objc private func didViewTapped(sender: UITapGestureRecognizer) {
        let leftRectangle = CGRect(
            x: .zero,
            y: .zero,
            width: frame.width / 2,
            height: frame.height
        )
        let location = sender.location(in: self)
        if leftRectangle.contains(location) {
            responder.object?.usernameTapped()
        } else {
            responder.object?.phoneTapped()
        }
    }
}

extension FilterView {
    struct ViewModel {
        let filterState: FilterSelectionState
    }
    
    func configure(viewModel: FilterView.ViewModel) {
        layoutIfNeeded()
        
        if preSelectionStateActive {
            selectedContainer.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(spacer.space6)
                make.width.equalTo((frame.width / 2) - spacer.space6)
            }
            preSelectionStateActive = false
        } else {
            switch viewModel.filterState {
            case .username:
                UIView.animate(withDuration: 0.1, delay: .zero) {
                    self.leftTitle.textColor = .black
                    self.rightTitle.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
                    self.selectedContainer.snp.remakeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(6)
                        make.leading.equalToSuperview().inset(6)
                        make.width.equalTo((self.frame.width / 2) - self.spacer.space6)
                    }
                    self.layoutIfNeeded()
                }
            case .phoneNumber:
                UIView.animate(withDuration: 0.1, delay: .zero) {
                    self.rightTitle.textColor = .black
                    self.leftTitle.textColor = UIColor(red: 136 / 255, green: 153 / 255, blue: 168 / 255, alpha: 1)
                    self.selectedContainer.snp.remakeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(6)
                        make.trailing.equalToSuperview().inset(6)
                        make.width.equalTo((self.frame.width / 2) - self.spacer.space6)
                    }
                    self.layoutIfNeeded()
                }
            }
        }
    }
}
