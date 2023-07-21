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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.obtainInitialState()
        navigationController?.setNavigationBarHidden(true, animated: false)
//        title = "Welcome"
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        setNavigationBarTint(
//            with: UIViewController.NavigationBarConfiguration(
//                tintColor: .black,
//                barTintColor: UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1),
//                textColor: .black,
//                isTranslucent: false,
//                backgroundImage: UIImage(),
//                shadowImage: UIImage()
//            ),
//            coordinatedTransition: false
//        )
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
}

extension UserDetailsScreenViewController: UserDetailsScreenEventsRespondable {
    func didCloseButtonTapped() {
        dismisser.dismiss(productViewController: self)
    }
    
    func didSelectCell(index: Int) {
        interactor.obtainSelectedCell(index: index)
    }
}
