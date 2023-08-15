import UIKit
import SnapKit
import AudioToolbox

private extension Spacer {
    var viewSize: CGFloat { 32 }
}

protocol UserActionsViewEventsRespondable {
    func imageSelected(id: Int?)
}

public final class UserActionsView: UIView {
    // MARK: - Subview Properties
    
    private lazy var blurView: UIView = {
        let view = UIView()
        view.blur(blurStyle: .light)
        view.clipsToBounds = true
        view.layer.cornerRadius = spacer.space20
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = -spacer.space16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var closeView: ImageFillerView<SmallGrayWithoutAlphaFillerViewStyle> = {
        let view = ImageFillerView<SmallGrayWithoutAlphaFillerViewStyle>()
        view.configure(with: .init(image: Images.closeImage.withTintColor(Color.current.background.whiteColor)))
        view.isHidden = true
        return view
    }()
    
    private lazy var responder = Weak(firstResponder(of: UserActionsViewEventsRespondable.self))
    private var prevView = UIView()
    private var viewModels: [ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel] = []
    private var selectedID: Int?

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
        backgroundColor = .clear
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        longTap.minimumPressDuration = 0.12
        addGestureRecognizer(longTap)
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(blurView)
        blurView.addSubview(stackView)
    }

    private func makeConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStack(viewModels: [ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel]) {
        viewModels.forEach { viewModel in
            let view = ImageFillerView<SmallWhiteFillerViewStyle>()
            view.isUserInteractionEnabled = false
            view.snp.makeConstraints { make in
                make.size.equalTo(spacer.viewSize)
            }
            view.configure(with: viewModel)
            stackView.addArrangedSubview(view)
        }
        
        closeView.snp.makeConstraints { make in
            make.size.equalTo(spacer.viewSize)
        }
        stackView.addArrangedSubview(closeView)
        
        stackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(spacer.space4)
        }
    }
    
    private func changeViewToExpanded() {
        UIView.animate(withDuration: 0.15, delay: .zero, options: .curveEaseIn, animations: {
            self.closeView.isHidden = false
            self.closeView.rotate(duration: 0.4)
            self.stackView.spacing = self.spacer.space12
            self.stackView.distribution = .equalSpacing
            self.stackView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(self.spacer.space6)
            }
            self.layoutIfNeeded()
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.closeView.stopRotating()
            }
        })
    }
    
    private func changeViewToCollapsed() {
        UIView.animate(withDuration: 0.15, delay: .zero, options: .curveEaseOut) {
            self.closeView.isHidden = true
            self.stackView.spacing = -self.spacer.space16
            self.stackView.distribution = .fillEqually
            self.stackView.snp.updateConstraints { make in
                make.edges.equalToSuperview().inset(self.spacer.space4)
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc private func longTap(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            changeViewToExpanded()
            stackView.subviews.enumerated().forEach { index, subview in
                changeSizeOfSelectedView(index: index, transform: .identity)
            }
        case .changed:
            let location = sender.location(in: self)
            
            if
                let view = stackView.subviews.first(where: { $0.frame.contains(location) }) {
                if view != prevView {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    prevView = view
                    if let castedView = view as? ImageFillerView<SmallWhiteFillerViewStyle> {
                        selectedID = castedView.id
                    }
                }
            } else {
                selectedID = nil
            }
            
            stackView.subviews.enumerated().forEach { index, subview in
                if subview.frame.contains(location) {
                    changeSizeOfSelectedView(
                        index: index,
                        transform: CGAffineTransform(scaleX: 1.2, y: 1.2)
                    )
                } else {
                    changeSizeOfSelectedView(index: index, transform: .identity)
                }
            }
        case .ended, .failed, .cancelled:
            changeViewToCollapsed()
            stackView.subviews.enumerated().forEach { index, subview in
                changeSizeOfSelectedView(index: index, transform: .identity)
            }
            responder.object?.imageSelected(id: selectedID)
        default:
            return
        }
    }
    
    private func changeSizeOfSelectedView(index: Int, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.1, delay: .zero) {
            self.stackView.subviews[index].transform = transform
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Configurable

extension UserActionsView {
    public struct ViewModel {
        let viewModels: [ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel]
        let closeButtonBackground: UIColor
    }

    public func configure(with viewModel: ViewModel) {
        viewModels = viewModel.viewModels
        stackView.subviews.forEach { $0.removeFromSuperview() }
        setupStack(viewModels: viewModel.viewModels)
        closeView.changeBackground(with: viewModel.closeButtonBackground)
    }
}
