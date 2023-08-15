import UIKit

final class UserDetailsScreenViewController: UIViewController {
    public let contentView = UserDetailsScreenView()
    
    private let interactor: UserDetailsScreenInteractor
    private let dismisser: TransitionDismisser
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.updateMainActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.obtainInitialState()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public init(
        interactor: UserDetailsScreenInteractor,
        dismisser: TransitionDismisser
    ) {
        self.interactor = interactor
        self.dismisser = dismisser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
}

extension UserDetailsScreenViewController {
    func display(viewModel: UserDetailsScreenView.ViewModel) {
        contentView.configure(with: viewModel)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { _ in alert.dismiss(animated: true) }))
        alert.addAction(
            UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { [weak self] _ in
                    self?.interactor.obtainBlock()
                }
            )
        )
        present(alert, animated: true)
    }
    
    func displayCallScreen(title: String) {
        let callViewController = CallsAssembly().assemble(title: title)
        callViewController.modalPresentationStyle = .overFullScreen
        present(callViewController, animated: true)
    }
}

extension UserDetailsScreenViewController: UserDetailsScreenEventsRespondable {
    func didCloseButtonTapped() {
        dismisser.dismiss(productViewController: self)
    }
    
    func didOKButtonTapped(
        titleText: String,
        descriptionText: String,
        noticeText: String
    ) {
        interactor.obtainOKButton(
            titleText: titleText,
            descriptionText: descriptionText,
            noticeText: noticeText
        )
    }
}

extension UserDetailsScreenViewController: ImageFillerViewEventsRespondable {
    func imageTapped(id: Int) {
        interactor.obtainMainAction(id: id)
    }
}

extension UserDetailsScreenViewController: UserActionsViewEventsRespondable {
    func imageSelected(id: Int?) {
        interactor.obtainAdditionalAction(id: id)
    }
}
