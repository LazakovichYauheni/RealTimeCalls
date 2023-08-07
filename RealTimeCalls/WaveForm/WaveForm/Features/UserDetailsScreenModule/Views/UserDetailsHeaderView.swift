import UIKit
import SnapKit

private extension Spacer {
    var space44: CGFloat { 44 }
    var space100: CGFloat { 100 }
    var spacing: CGFloat { ((UIScreen.main.bounds.width - 122) - (3 * 48)) / 2 }
}

/// View для заполнения иконок с фоном
public final class UserDetailsHeaderView: UIView {
    // MARK: - Subview Properties

    private(set) lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var additionalActionsView: UserActionsView = {
        let view = UserActionsView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var mainActionsContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = spacer.space28
        view.blur(blurStyle: .light)
        return view
    }()
    
    private lazy var mainActionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = -spacer.space48
        return stack
    }()

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMainActionsStack() {
        UIView.animate(withDuration: 0.2, delay: .zero, options: .curveEaseOut) {
            self.mainActionsStackView.spacing = self.spacer.spacing
            self.mainActionsContainerView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(self.spacer.space44)
                make.leading.equalToSuperview().inset(self.spacer.space10)
                make.trailing.equalToSuperview().inset(self.spacer.space100)
            }
            self.layoutIfNeeded()
        }
        
        addGradientBorder(to: mainActionsStackView.subviews[0])
        addParallaxToView(vw: iconImageView)
    }

    // MARK: - Private Methods

    private func commonInit() {
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(additionalActionsView)
        addSubview(mainActionsContainerView)
        mainActionsContainerView.addSubview(mainActionsStackView)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        additionalActionsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space44)
            make.trailing.equalToSuperview().inset(spacer.space28)
        }
        
        mainActionsContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(spacer.space44)
            make.leading.equalToSuperview().inset(spacer.space10)
            make.trailing.lessThanOrEqualToSuperview().inset(spacer.space100)
        }
        
        mainActionsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(spacer.space6)
        }
    }
    
    private func setupStack(views: [ImageFillerView<DefaultLargeFillerViewStyle>]) {
        views.forEach {
            mainActionsStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Configurable

extension UserDetailsHeaderView {
    public struct ViewModel {
        let userImage: UIImage
        let mainActions: [ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel]
        let additionalActionsViewModel: UserActionsView.ViewModel
        let actionsBackground: UIColor
    }

    public func configure(with viewModel: ViewModel) {
        iconImageView.image = viewModel.userImage
        let editedMainActions = viewModel.mainActions.map {
            let view = ImageFillerView<DefaultLargeFillerViewStyle>()
            view.configure(with: $0)
            view.changeBackground(with: viewModel.actionsBackground)
            return view
        }
        setupStack(views: editedMainActions)
        additionalActionsView.configure(with: viewModel.additionalActionsViewModel)
    }
}
