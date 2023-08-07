import UIKit
import FloatingPanel

final class AllContactsViewController: UIViewController {
    public let contentView = AllContactsView()
    public var currentCell: ContactTableViewCell?
    
    private let interactor: AllContactsInteractor
    private let transitionPresenter = TransitionPresenter()
    
    private lazy var addUserButton: UIBarButtonItem = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUser)))
        imageView.image = Images.addImage.withTintColor(Color.current.text.lightBlueColor)
        
        let item = UIBarButtonItem(customView: imageView)
        return item
    }()
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.obtainInitialState()
        title = "All Contacts"
        navigationItem.setRightBarButton(addUserButton, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: Color.current.background.blackColor,
                barTintColor: Color.current.background.mainColor,
                textColor: Color.current.text.blackColor,
                isTranslucent: true,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: AllContactsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    @objc private func addUser() {
        let addUserViewController = AddUserViewController()
        
        let floatingController = FloatingPanelController()
        let surfaceAppearance = SurfaceAppearance()
        let layout = FloatingLayout()
        surfaceAppearance.backgroundColor = Color.current.background.mainColor
        surfaceAppearance.shadows = []
        surfaceAppearance.cornerRadius = spacer.space16
        floatingController.surfaceView.appearance = surfaceAppearance
        floatingController.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingController.layout = layout
        
        floatingController.set(contentViewController: addUserViewController)
        navigationController?.present(floatingController, animated: true)
    }
}

extension AllContactsViewController {
    func display(viewModel: AllContactsView.ViewModel) {
        contentView.configure(with: viewModel)
    }
    
    func displayContactDetails(contact: Contact) {
        transitionPresenter.present(
            .init(
                name: contact.firstName,
                lastName: contact.firstName,
                infoMessage: contact.firstName,
                image: Images.girlImage,
                callImage:Images.girlImage,
                isNeedToShowBorder: false,
                backgroundColor: UIColor(hue: 0.5, saturation: 0.44, brightness: 0.76, alpha: 1),
                buttonBackground: UIColor(hue: 0.5, saturation: 0.44, brightness: 0.59, alpha: 1)
            ),
            from: self,
            duration: 0.2
        )
    }
}


extension AllContactsViewController: AllContactsViewEventsRespondable {
    func didSelectCell(index: Int, cell: ContactTableViewCell) {
        currentCell = cell
        interactor.obtainSelectedCell(index: index)
    }
}

class FloatingLayout: FloatingPanelLayout {
    public let position: FloatingPanelPosition = .bottom
    public let initialState: FloatingPanelState = .full

    public var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        [.full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: .zero)]
    }
    
    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.7
    }
}
