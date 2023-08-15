import UIKit
import SnapKit

private extension Spacer {
    var imageHeightMultiplier: CGFloat { 0.64 }
}

protocol UserDetailsScreenEventsRespondable {
    func didCloseButtonTapped()
    func didOKButtonTapped(
        titleText: String,
        descriptionText: String,
        noticeText: String
    )
}

public final class UserDetailsScreenView: UIView {
    // MARK: - Subview Properties
    
    private(set) lazy var headerView = UserDetailsHeaderView()

    private(set) lazy var contentView = UserDetailsContentView()
    
    private lazy var responder = Weak(firstResponder(of: UserDetailsScreenEventsRespondable.self))
    
    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMainActions() {
        headerView.updateMainActionsStack()
    }

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(headerView)
        addSubview(contentView)
    }

    private func makeConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(spacer.imageHeightMultiplier)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(-spacer.space20)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension UserDetailsScreenView {
    public struct ViewModel {
        let headerViewModel: UserDetailsHeaderView.ViewModel
        let contentViewModel: UserDetailsContentView.ViewModel
        let isEditMode: Bool
    }

    public func configure(with viewModel: ViewModel) {
        headerView.configure(with: viewModel.headerViewModel)
        contentView.configure(with: viewModel.contentViewModel)
        if viewModel.isEditMode {
            UIView.animate(withDuration: 0.3) {
                self.contentView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(self.spacer.space40)
                    make.bottom.leading.trailing.equalToSuperview()
                }
                self.layoutIfNeeded()
            }
        }
    }
}

extension UserDetailsScreenView: UserDetailsContentViewEventsRespondable {
    func didCloseButtonTapped() {
        headerView.hideContent()
        responder.object?.didCloseButtonTapped()
    }
    
    func didOKButtonTapped(
        titleText: String,
        descriptionText: String,
        noticeText: String
    ) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.snp.remakeConstraints { make in
                make.top.equalTo(self.headerView.snp.bottom).offset(-self.spacer.space20)
                make.bottom.leading.trailing.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
        responder.object?.didOKButtonTapped(
            titleText: titleText,
            descriptionText: descriptionText,
            noticeText: noticeText
        )
    }
}
