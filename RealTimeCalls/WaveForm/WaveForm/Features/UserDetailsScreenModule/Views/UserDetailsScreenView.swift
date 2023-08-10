import UIKit
import SnapKit

private extension Spacer {
    var imageHeightMultiplier: CGFloat { 0.64 }
}

public final class UserDetailsScreenView: UIView {
    // MARK: - Subview Properties
    
    private(set) lazy var headerView = UserDetailsHeaderView()

    private(set) lazy var contentView = UserDetailsContentView()
    
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
    }

    public func configure(with viewModel: ViewModel) {
        headerView.configure(with: viewModel.headerViewModel)
        contentView.configure(with: viewModel.contentViewModel)
    }
}
