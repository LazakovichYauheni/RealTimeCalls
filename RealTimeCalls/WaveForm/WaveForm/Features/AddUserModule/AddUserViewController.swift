import UIKit
import NotificationBannerSwift

final class AddUserViewController: UIViewController {
    public let contentView = AddUserView()
    
    private var observer: FloatingObservable?
    private var prevContentViewHeight: CGFloat = .zero
    private var contentWithContactsHeight: CGFloat = .zero
    
    private let interactor: AddUserInteractor
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.obtain()
    }
    
    public init(interactor: AddUserInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    public func setObserver(_ observer: FloatingObservable) {
        self.observer = observer
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if prevContentViewHeight == .zero {
            prevContentViewHeight = contentView.frame.height
        }
    }
}

extension AddUserViewController {
    func display(viewModel: AddUserView.ViewModel) {
        contentView.configure(with: viewModel)
        if !viewModel.isInitialState {
            contentView.updateHeight()
        }
    }
    
    func showAlert(string: String) {
        let banner = FloatingNotificationBanner(subtitle: string, subtitleTextAlign: .center, style: .success)
        banner.autoDismiss = true
        banner.show(
            cornerRadius: spacer.space12,
            shadowColor: Color.current.background.shadowColor,
            shadowBlurRadius: spacer.space16
        )
        dismiss(animated: true)
    }
}

extension AddUserViewController: AddUserViewEventsRespondable {
    func sendKeyboardHeight(height: CGFloat) {
        observer?.updateHeight(height: height + prevContentViewHeight)
    }
    
    func didTapCell(id: Int) {
        interactor.obtainSelectedContact(id: id)
    }
}

extension AddUserViewController: FloatingTextFieldEventsRespondable {
    func textFieldDidBeginEditing(text: String, id: String) {
        interactor.obtainBeginEditing(text: text, id: id)
    }
    
    func textFieldDidChange(text: String, id: String) {
        interactor.obtainTextChanging(text: text, id: id)
    }
    
    func textFieldDidEndEditing(text: String, id: String) {}
}

extension AddUserViewController: FloatingTextFieldViewEventsRespondable {
    func tapRightIconButton(id: String) {
        interactor.obtainClearButton()
    }
    
    func tapSuccessIconButton(id: String) {
        interactor.obtainSuccess()
    }
}
